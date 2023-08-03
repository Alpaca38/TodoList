//
//  CompletedTodoViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/01.
//

import UIKit

class CompletedViewController: UITableViewController, TodoDetailViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = UserDefaults.standard.value(forKey: "completedItems") as? Data {
            if let savedTodoItems = try? JSONDecoder().decode([TodoItem].self, from: data) {
                DataManager.shared.completedItems = savedTodoItems
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.completedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTodoCell", for: indexPath)
        let completedItem = DataManager.shared.completedItems[indexPath.row]
        
        cell.textLabel?.text = completedItem.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodoItem = DataManager.shared.completedItems[indexPath.row]
        performSegue(withIdentifier: "ShowTodoDetail", sender: selectedTodoItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTodoDetail" {
            //segue.destination은 UIViewController 타입을 반환하므로 TodoDetailViewController 캐스팅
            //sender: 세그웨이에서 전달되는 데이터
            if let todoDetailVC = segue.destination as? TodoDetailViewController,
               let selectedTodoItem = sender as? TodoItem {
                todoDetailVC.todoItem = selectedTodoItem
                todoDetailVC.delegate = self
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
    
    func deleteTodoItem(_ item: TodoItem) {
        if let index = DataManager.shared.completedItems.firstIndex(where: { $0.title == item.title}) {
            DataManager.shared.completedItems.remove(at: index)
            UserDefaults.standard.set(try? JSONEncoder().encode(DataManager.shared.completedItems), forKey: "completedItems")
            tableView.reloadData()
        }
    }
}
