//
//  ProfileViewModel.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//

import Foundation
// 뷰의 상태들을 갖고있고 뷰를 업데이트 해주어야 하기 때문에 Delegate 채용
protocol UserViewModelDelegate: AnyObject {
    func updateUserName(name: String)
    func updateUserAge(age: Int)
}

class UserViewModel {
    private var user: User
    weak var delegate: UserViewModelDelegate?
    
    init(user: User) {
        self.user = user
    }
    // lazy : 프로퍼티에 접근할 때까지 값이 초기화되지 않는다.
    lazy var userName: String = user.name {
        // didSet : 값이 설정될 때 마다 실행
        didSet {
            // 사용자 이름의 변경사항을 delegate에 알림
            delegate?.updateUserName(name: userName)
        }
    }
    
    lazy var userAge: Int = user.age {
        didSet {
            delegate?.updateUserAge(age: userAge)
        }
    }
}
