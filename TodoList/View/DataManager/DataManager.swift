//
//  DataManager.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/01.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    
    var completedItems: [TodoItem] = []
    
    private init() {}
}
