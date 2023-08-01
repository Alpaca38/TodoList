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
}

class TodoViewController: UITableViewController {
    
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(try? JSONEncoder().encode(todoItems), forKey: "todoItems")
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
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self, weak alertController] _ in
            if let textField = alertController?.textFields?.first, let title = textField.text, !title.isEmpty {
                let newTodoItem = TodoItem(title: title, isCompleted: false )
                self?.todoItems.append(newTodoItem)
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
    
    func moveToCompleted(at index: Int) {
        let completedItem = todoItems.remove(at: index)
        DataManager.shared.completedItems.append(completedItem)
        tableView.reloadData()
    }
}
