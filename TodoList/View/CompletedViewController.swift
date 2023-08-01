//
//  CompletedTodoViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/01.
//

import UIKit

class CompletedViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
}
