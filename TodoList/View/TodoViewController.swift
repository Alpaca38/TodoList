//
//  SecondViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/07/31.
//

import UIKit

struct TodoItem: Codable {
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
}

class TodoViewController: UITableViewController, TodoDetailViewControllerDelegate {
    
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = UserDefaults.standard.value(forKey: "todoItems") as? Data {
            if let savedTodoItems = try? JSONDecoder().decode([TodoItem].self, from: data) {
                todoItems = savedTodoItems
                tableView.reloadData()
            }
        }
    }
    
    func setupNavigationBar() {
        title = "Todo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodoItem))
    }
    
    @objc func addTodoItem() {
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
                UserDefaults.standard.set(try? JSONEncoder().encode(self?.todoItems), forKey: "todoItems")
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
            UserDefaults.standard.set(try? JSONEncoder().encode(todoItems), forKey: "todoItems")
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func moveToCompleted(at index: Int) {
        let completedItem = todoItems.remove(at: index)
        UserDefaults.standard.set(try? JSONEncoder().encode(todoItems), forKey: "todoItems")
        DataManager.shared.completedItems.append(completedItem)
        UserDefaults.standard.set(try? JSONEncoder().encode(DataManager.shared.completedItems), forKey: "completedItems")
        tableView.reloadData()
    }
    
    func deleteTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.title == item.title}) {
            todoItems.remove(at: index)
            UserDefaults.standard.set(try? JSONEncoder().encode(todoItems), forKey: "todoItems")
            tableView.reloadData()
        }
    }
}
