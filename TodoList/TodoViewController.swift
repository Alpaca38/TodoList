//
//  SecondViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/07/31.
//

import UIKit

class TodoViewController: UITableViewController {
    
    struct TodoItem {
        var title: String
        var isCompleted: Bool
    }
    
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.reloadData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todoItem = todoItems[indexPath.row]
        cell.textLabel?.text = todoItem.title
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = todoItem.isCompleted
        toggleSwitch.addTarget(self, action: #selector(toggleCompletion), for: .valueChanged)
        toggleSwitch.tag = indexPath.row
        
        cell.contentView.addSubview(toggleSwitch)
        
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16).isActive = true
        toggleSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        
        
        if todoItem.isCompleted {
            cell.textLabel?.attributedText = NSAttributedString(string: todoItem.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        } else {
            cell.textLabel?.attributedText = NSAttributedString(string: todoItem.title, attributes: [.strikethroughStyle: NSUnderlineStyle(rawValue: 0)])
        }
        
        return cell
    }
    
    @objc func toggleCompletion(_ sender: UISwitch) {
        let index = sender.tag
        var todoItem = todoItems[index]
        todoItem.isCompleted = sender.isOn
        todoItems[index] = todoItem
        
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            if todoItem.isCompleted {
                cell.textLabel?.attributedText = NSAttributedString(string: todoItem.title, attributes: [.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            } else {
                cell.textLabel?.attributedText = NSAttributedString(string: todoItem.title, attributes: [.strikethroughStyle: NSUnderlineStyle(rawValue: 0)])
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todoItems[indexPath.row]
        let newCompletedState = !selectedTodo.isCompleted
        todoItems[indexPath.row].isCompleted = newCompletedState
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
