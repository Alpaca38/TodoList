//
//  Task+CoreDataProperties.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var createDate: Date?
    @NSManaged public var modifyDate: Date?
    @NSManaged public var isCompleted: Bool

}

extension Task : Identifiable {

}
