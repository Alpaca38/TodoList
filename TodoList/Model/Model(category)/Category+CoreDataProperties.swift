//
//  Category+CoreDataProperties.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension Category : Identifiable {

}
