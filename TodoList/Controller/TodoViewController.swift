//
//  SecondViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/07/31.
//

import UIKit

class TodoViewController: UITableViewController{
    
//    var categories: [String] = []
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        TodoManager.shared.loadTodoItem()
        setupCategories()
        tableView.reloadData()
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
//        alertController.addTextField { textField in textField.placeholder = "마감일: yyyy-MM-dd HH:mm"}
        alertController.addTextField {
            textField in textField.placeholder = "카테고리"
        }
        //뷰 컨트롤러 내에서 클로저를 사용할 때 인스턴스를 사용해야한다면 약한참조를 해야 함! 메모리 누수 방지
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self, weak alertController] _ in
            if let titleField = alertController?.textFields?[0],
//               let dueDateField = alertController?.textFields?[1],
               let categoryField = alertController?.textFields?[1],
               let title = titleField.text, !title.isEmpty {
                
//                let dueDateText = dueDateField.text
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//                let dueDate = dateFormatter.date(from: dueDateText ?? "")
//
//                let category = Category()
//                category.title = categoryField.text
//                category.id = UUID()
              
                    
                
                CategoryManager.shared.saveCategory(id: UUID(), title: categoryField.text) {
                    print("category 저장 성공")
                }
                let category = CategoryManager.shared.getCategoryCoreData().first(where: { $0.title == categoryField.text})
                
                
//                let newTodoItem = TodoItem(id: UUID(), title: title, isCompleted: false, dueDate: dueDate, category: categoryField.text ?? "")
//                TodoManager.shared.addTodoItem(newTodoItem)
                TaskManager.shared.saveTask(id: UUID(), title: title, createDate: Date(), modifyDate: Date(), isCompleted: false, category: category) {
                    print("Task 저장 성공")
                }
                self?.setupCategories()
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
    
    func setupCategories() {
        // Set : 중복을 허용하지 않는다.
//        categories = Array(Set(TodoManager.shared.todoItems.map { $0.category })).sorted()
        categories = CategoryManager.shared.getCategoryCoreData()
    }
    
    func getTodoFromCategory(at indexPath: IndexPath) -> Task? {
//        let category = categories[indexPath.section]
//        let itemsInCategory = TodoManager.shared.todoItems.filter { $0.category == category }
        let category = categories[indexPath.section]
        let itemsInCategory = TaskManager.shared.getTaskCoreData().filter { $0.category == category }
        return itemsInCategory[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        guard let todoItem = getTodoFromCategory(at: indexPath) else { return cell }
        cell.textLabel?.text = todoItem.title
        cell.toggleSwitch.isOn = todoItem.isCompleted
        cell.toggleSwitch.addTarget(self, action: #selector(toggleCompletion), for: .valueChanged)
        cell.toggleSwitch.tag = indexPath.row
        
        return cell
    }
    
    @objc func toggleCompletion(_ sender: UISwitch) {
        // 토글 버튼이 위치한 셀
        guard let cell = sender.superview?.superview as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell),
              let task = getTodoFromCategory(at: indexPath) else {
            return
        }
        
        task.isCompleted = sender.isOn
        
        if sender.isOn {
            if let completedVC = storyboard?.instantiateViewController(withIdentifier: "ShowCompleted") as? CompletedViewController {
                completedVC.selectedCompletedItem = task
            }
            TaskManager.shared.updateTask(newToDoData: task) {
                print("완료상태 저장")
            }
        }
}
    
//    func moveToCompleted(at indexPath: IndexPath) {
//        guard let completedItem = getTodoFromCategory(at: indexPath) else {return}
////        TodoManager.shared.todoItems.removeAll { $0.id == completedItem.id }
////        TodoManager.shared.saveTodoItem()
//        TaskManager.shared.deleteTask(data: completedItem) {
//            print("삭제 성공")
//        }
//
////        CompletedManager.shared.addTodoItem(completedItem)
//
//
//        tableView.reloadData()
//    }
}

// Table View Data Source
extension TodoViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = categories[section]
//        return TodoManager.shared.todoItems.filter { $0.category == category }.count
        return TaskManager.shared.getTaskCoreData().filter { $0.category == category }.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = categories[section]
//        let itemsInCategory = TodoManager.shared.todoItems.filter { $0.category == category }
        let itemsInCategory = TaskManager.shared.getTaskCoreData().filter { $0.category == category }
        return itemsInCategory.isEmpty ? nil : category.title
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
}

// Table View Editing
extension TodoViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // category 추가
            guard let itemToDelete = getTodoFromCategory(at: indexPath) else {return}
            
//            if let index = TodoManager.shared.todoItems.firstIndex(of: itemToDelete) {
//                TodoManager.shared.todoItems.remove(at: index)
//            }
            TaskManager.shared.deleteTask(data: itemToDelete) {
                print("삭제 성공")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
//            TodoManager.shared.saveTodoItem()
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
////        let itemToMove = TodoManager.shared.todoItems[sourceIndexPath.row]
////        TodoManager.shared.todoItems.remove(at: sourceIndexPath.row)
////        TodoManager.shared.todoItems.insert(itemToMove, at: destinationIndexPath.row)
////        TodoManager.shared.saveTodoItem()
//    }
}

// Navigation
extension TodoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedTodoItem = getTodoFromCategory(at: indexPath) else {return}
        performSegue(withIdentifier: "ShowTodoDetail", sender: selectedTodoItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTodoDetail" {
            //segue.destination은 UIViewController 타입을 반환하므로 TodoDetailViewController 캐스팅
            //sender: 세그웨이에서 전달되는 데이터
            if let todoDetailVC = segue.destination as? TodoDetailViewController,
               let selectedTodoItem = sender as? Task {
                todoDetailVC.task = selectedTodoItem
            }
        }
    }
}
