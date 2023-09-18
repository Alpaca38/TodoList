//
//  CompletedManager.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/24.
//

import Foundation

class CompletedManager {
    static let shared = CompletedManager()
    
    private init() {}
    
    var completedItems: [Task] = []
    
//    func addTodoItem(_ completedItem: TodoItem) {
//        completedItems.append(completedItem)
//        saveCompletedItem()
//    }
//    
//    func updateTodoItem(_ updatedItem: TodoItem) {
//        if let index = completedItems.firstIndex(where: { $0.id == updatedItem.id }) {
//                completedItems[index] = updatedItem
//                saveCompletedItem()
//            }
//    }
//    
//    func deleteTodoItem(_ todoItem: TodoItem) {
//        if let index = completedItems.firstIndex(where: { $0.title == todoItem.title }) {
//            completedItems.remove(at: index)
//        }
//        saveCompletedItem()
//    }
//    
//    func saveCompletedItem() {
//        UserDefaults.standard.set(try? JSONEncoder().encode(completedItems), forKey: "completedItems")
//    }
//    
//    func loadCompletedItem() {
//        if let data = UserDefaults.standard.value(forKey: "completedItems") as? Data {
//            if let savedTodoItems = try? JSONDecoder().decode([TodoItem].self, from: data) {
//                completedItems = savedTodoItems
//            }
//        }
//    }
}
