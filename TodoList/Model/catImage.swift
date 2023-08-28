//
//  catImage.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/28.
//

import Foundation

struct CatImage: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}
