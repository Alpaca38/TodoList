//
//  TodoManager.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/24.
//

import Foundation

class TodoManager {
    static let shared = TodoManager()
    
    private init() { }
    
    var todoItems: [TodoItem] = []
    
    func addTodoItem(_ todoItem: TodoItem) {
        todoItems.append(todoItem)
        saveTodoItem()
    }
    
    func updateTodoItem(_ updatedItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == updatedItem.id }) {
                todoItems[index] = updatedItem
                saveTodoItem()
            }
    }
    
    func deleteTodoItem(_ todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.title == todoItem.title }) {
            todoItems.remove(at: index)
            saveTodoItem()
        }
    }
    
    func saveTodoItem() {
        UserDefaults.standard.set(try? JSONEncoder().encode(todoItems), forKey: "todoItems")
    }
    
    func loadTodoItem() {
        if let data = UserDefaults.standard.value(forKey: "todoItems") as? Data {
            if let savedTodoItems = try? JSONDecoder().decode([TodoItem].self, from: data) {
                todoItems = savedTodoItems
            }
        }
    }
}
