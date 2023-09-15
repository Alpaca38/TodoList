//
//  CategoryCore.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//

import CoreData
import UIKit

//MARK: - 관리하는 매니저 (코어데이터 관리) /

final class CategoryManager {
    
    static let shared = CategoryManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "Category"
    
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveCategory(id: UUID?, title: String?, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                let category = Category(entity: entity, insertInto: context)
                
                category.id = id
                category.title = title
                
                appDelegate?.saveContext()
            }
        }
        completion()
    }
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getCategoryCoreData() -> [Category] {
        var category: [Category] = []
        if let context = context {
            let request = NSFetchRequest<Category>(entityName: self.modelName)
            
            do {
                let fetchedCategory = try context.fetch(request)
                category = fetchedCategory
            } catch {
                print("가져오는 것 실패")
            }
        }
        return category
    }
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateCategory(newToDoData: Category, completion: @escaping () -> Void) {
        
        if let context = context {
            let request = NSFetchRequest<Category>(entityName: self.modelName)
            
            do {
                if var fetchedCategory = try context.fetch(request).first {
                    fetchedCategory = newToDoData
                    appDelegate?.saveContext()
                }
                completion()
            } catch {
                print("업데이트 실패")
            }
        }
    }
}

