//
//  ProfileViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel!
    
    var nameLabel: UILabel!
    var ageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bindViewModel()
    }
}

