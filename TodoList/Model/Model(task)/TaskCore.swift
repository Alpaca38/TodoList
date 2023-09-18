//
//  TaskCore.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//

import CoreData
import UIKit

//MARK: - To do 관리하는 매니저 (코어데이터 관리) /

final class TaskManager {
    
    static let shared = TaskManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "Task"
    
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveTask(id: UUID?, title: String?, createDate: Date?, modifyDate: Date?, isCompleted: Bool, category: Category?, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                let task = Task(entity: entity, insertInto: context)
                
                task.id = id
                task.title = title
                task.createDate = createDate
                task.modifyDate = modifyDate
                task.isCompleted = isCompleted
                task.category = category
                
                appDelegate?.saveContext()
            }
        }
        completion()
    }
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getTaskCoreData() -> [Task] {
        var task: [Task] = []
        if let context = context {
            let request = NSFetchRequest<Task>(entityName: self.modelName)
            
            do {
                let fetchedTask = try context.fetch(request)
                task = fetchedTask
            } catch {
                print("가져오는 것 실패")
            }
        }
        return task
    }
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateTask(newToDoData: Task, completion: @escaping () -> Void) {
        
        if let context = context {
            let request = NSFetchRequest<Task>(entityName: self.modelName)
            
            do {
                if var fetchedTask = try context.fetch(request).first {
                    fetchedTask = newToDoData
                    appDelegate?.saveContext()
                }
                completion()
            } catch {
                print("업데이트 실패")
            }
        }
    }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteTask(data: Task, completion: @escaping () -> Void) {
        guard let modifyDate = data.modifyDate else {
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<Task>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "modifyDate = %@", modifyDate as CVarArg)
            
            do {
                let fetchedSnack = try context.fetch(request)
                
                if let targetSnack = fetchedSnack.first {
                    context.delete(targetSnack)
                    appDelegate?.saveContext()
                }
                completion()
            } catch {
                print("지우는 것 실패")
            }
        }
    }
}
