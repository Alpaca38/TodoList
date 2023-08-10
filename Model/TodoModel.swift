//
//  TodoModel.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/09.
//

import Foundation

struct TodoItem: Codable {
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
}
