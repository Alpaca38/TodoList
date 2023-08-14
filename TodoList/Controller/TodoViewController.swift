//
//  SecondViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/07/31.
//

import UIKit

class TodoViewController: UITableViewController, TodoDetailViewControllerDelegate {
    
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editTableView.dataSource = self
        self.editTableView.delegate = self
        setupNavigationBar()
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTodoItem()
    }
    
    @IBOutlet weak var editTableView: UITableView!
    
    @IBOutlet weak var editDoneButton: UIBarButtonItem!
    //버튼으로 isEditing모드 전환
    @IBAction func editTable(_sender: Any) {
        if self.editTableView.isEditing {
            self.editDoneButton.title = "Edit"
            self.editTableView.setEditing(false, animated: true)
        } else {
            self.editDoneButton.title = "Done"
            self.editTableView.setEditing(true, animated: true)
        }
    }
    
    @IBOutlet weak var addTodoButton: UIBarButtonItem!
    
    
    @IBAction func addTodoItem(_ sender: Any) {
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in textField.placeholder = "할 일을 입력하세요"}
        alertController.addTextField { textField in textField.placeholder = "마감일: yyyy-MM-dd HH:mm"}
        //뷰 컨트롤러 내에서 클로저를 사용할 때 인스턴스를 사용해야한다면 약한참조를 해야 함! 메모리 누수 방지
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self, weak alertController] _ in
            if let textField = alertController?.textFields?.first, let title = textField.text, !title.isEmpty {
                let dueDateTextField = alertController?.textFields?[1]
                let dueDateText = dueDateTextField?.text
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dueDate = dateFormatter.date(from: dueDateText ?? "")
                
                let newTodoItem = TodoItem(title: title, isCompleted: false, dueDate: dueDate )
                self?.todoItems.append(newTodoItem)
                self?.saveTodoItem()
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupNavigationBar() {
        title = "Todo List"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        let todoItem = todoItems[indexPath.row]
        cell.toggleSwitch.isOn = todoItem.isCompleted
        cell.toggleSwitch.addTarget(self, action: #selector(toggleCompletion), for: .valueChanged)
        cell.toggleSwitch.tag = indexPath.row
        
        if todoItem.isCompleted {
            cell.textLabel?.attributedText = NSAttributedString(string: todoItem.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        } else {
            cell.textLabel?.attributedText = NSAttributedString(string: todoItem.title, attributes: [.strikethroughStyle: NSUnderlineStyle(rawValue: 0)])
        }
        return cell
    }
    
    @objc func toggleCompletion(_ sender: UISwitch) {
        let index = sender.tag
        todoItems[index].isCompleted = sender.isOn
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            if todoItems[index].isCompleted {
                // String을 extension해서 밑줄을 긋는 함수 생성하는 식으로 파일 따로 생성해보기
                cell.textLabel?.attributedText = NSAttributedString(string: todoItems[index].title, attributes: [.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            } else {
                cell.textLabel?.attributedText = NSAttributedString(string: todoItems[index].title, attributes: [.strikethroughStyle: NSUnderlineStyle(rawValue: 0)])
            }
        }
        if sender.isOn {
            moveToCompleted(at: index)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodoItem = todoItems[indexPath.row]
        performSegue(withIdentifier: "ShowTodoDetail", sender: selectedTodoItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTodoDetail" {
            //segue.destination은 UIViewController 타입을 반환하므로 TodoDetailViewController 캐스팅
            //sender: 세그웨이에서 전달되는 데이터
            if let todoDetailVC = segue.destination as? TodoDetailViewController,
               let selectedTodoItem = sender as? TodoItem {
                todoDetailVC.todoItem = selectedTodoItem
                //상호작용 가능
                todoDetailVC.delegate = self
            }
        }
    }
    // fade-in animation
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveTodoItem()
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = todoItems[sourceIndexPath.row]
        todoItems.remove(at: sourceIndexPath.row)
        todoItems.insert(itemToMove, at: destinationIndexPath.row)
        saveTodoItem()
    }
    
    func moveToCompleted(at index: Int) {
        let completedItem = todoItems.remove(at: index)
        saveTodoItem()
        DataManager.shared.completedItems.append(completedItem)
        saveCompletedItem()
        tableView.reloadData()
    }
    
    func deleteTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.title == item.title}) {
            todoItems.remove(at: index)
            UserDefaults.standard.set(try? JSONEncoder().encode(todoItems), forKey: "todoItems")
            tableView.reloadData()
        }
    }
    
    func saveTodoItem() {
        UserDefaults.standard.set(try? JSONEncoder().encode(todoItems), forKey: "todoItems")
    }
    
    func saveCompletedItem() {
        UserDefaults.standard.set(try? JSONEncoder().encode(DataManager.shared.completedItems), forKey: "completedItems")
    }
    
    func loadTodoItem() {
        if let data = UserDefaults.standard.value(forKey: "todoItems") as? Data {
            if let savedTodoItems = try? JSONDecoder().decode([TodoItem].self, from: data) {
                todoItems = savedTodoItems
                tableView.reloadData()
            }
        }
    }
}
