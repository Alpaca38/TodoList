//
//  File.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/03.
//

import UIKit

//객체 사이의 상호작용을 가능하게 하는 디자인 패턴
protocol TodoDetailViewControllerDelegate: AnyObject {
    func deleteTodoItem(_ item: TodoItem)
}
