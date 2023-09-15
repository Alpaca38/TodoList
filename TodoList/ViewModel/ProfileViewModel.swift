//
//  ProfileViewModel.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//

import Foundation

class ProfileViewModel {
    var profileModel: Profile
    
    var userName: String {
        return profileModel.userName
    }
    
    var userAge: Int {
        return profileModel.userAge
    }
    
    init() {
        profileModel = Profile(userName: "규연", userAge: 26)
    }
}
