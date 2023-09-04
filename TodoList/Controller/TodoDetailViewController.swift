//
//  TodoDetailViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/02.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    var todoItem: TodoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    //하단에서 slide-in
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    weak var delegate: TodoDetailDelegate?
    
    func updateUI() {
        if let todoItem = todoItem {
            nameLabel.text = todoItem.title
            imageView.image = UIImage(named: "todoListImage")
            segmentedControl.selectedSegmentIndex = todoItem.isCompleted ? 1 : 0
            if let dueDate = todoItem.dueDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dueDateLabel.text = dateFormatter.string(from: dueDate)
            } else {
                dueDateLabel.text = "마감일 없음"
            }
        }
    }
    
    @IBAction func editTodoItem(_ sender: Any) {
        showEditAlert()
    }
    
    @IBAction func deleteTodoItem(_ sender: Any) {
        showDeleteAlert()
    }
    
    private func showEditAlert() {
        let alertController = UIAlertController(title: "할일 수정", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in textField.text = self.todoItem?.title
        }
        alertController.addTextField { textField in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            textField.text = self.todoItem?.dueDate != nil ? dateFormatter.string(from: self.todoItem!.dueDate!) : nil
            textField.placeholder = "yyyy-MM-dd HH:mm"
        }
        
        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self, weak alertController] _ in
            if let titleTextField = alertController?.textFields?.first, let title = titleTextField.text, !title.isEmpty {
                let dueDateTextField = alertController?.textFields?[1]
                let dueDateText = dueDateTextField?.text
                let dateFormmatter = DateFormatter()
                dateFormmatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dueDate = dateFormmatter.date(from: dueDateText ?? "")
                
                self?.todoItem?.title = title
                self?.todoItem?.dueDate = dueDate
                
                if let updatedItem = self?.todoItem {
                    TodoManager.shared.updateTodoItem(updatedItem)
                    CompletedManager.shared.updateTodoItem(updatedItem)
                }
                self?.updateUI()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showDeleteAlert() {
        let alertController = UIAlertController(title: "할일 삭제", message: "이 할일을 삭제하시겠습니까?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deleteTodoItem()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteTodoItem() {
        guard let todoItem = todoItem else {
            return
        }
        
        TodoManager.shared.deleteTodoItem(todoItem)
        CompletedManager.shared.deleteTodoItem(todoItem)
        //현재의 뷰 컨트롤러를 스택에서 제거하고 이전의 뷰 컨트롤러로 돌아감
        navigationController?.popViewController(animated: true)
    }
}
