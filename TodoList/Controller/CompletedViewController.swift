//
//  CompletedTodoViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/01.
//

import UIKit

class CompletedViewController: UITableViewController {
    
    var selectedCompletedItem: Task?
    var completedTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        CompletedManager.shared.loadCompletedItem()
        loadCompletedTasks()
        tableView.reloadData()
    }
    
    func loadCompletedTasks() {
        completedTasks = TaskManager.shared.getTaskCoreData().filter { $0.isCompleted }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return CompletedManager.shared.completedItems.count
        return completedTasks.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTodoCell", for: indexPath)
        let completedTask = completedTasks[indexPath.row]
        
        cell.textLabel?.text = completedTask.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodoItem = completedTasks[indexPath.row]
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
    //작아졌다 커지는 애니메이션
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            completedTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
