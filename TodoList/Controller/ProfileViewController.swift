//
//  ProfileViewController.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel!
    
    private var nameLabel: UILabel!
    private var ageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bindViewModel()
    }
}

private extension ProfileViewController {
    func configure() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textAlignment = .center
        
        ageLabel = UILabel()
        ageLabel.font = UIFont.systemFont(ofSize: 16)
        ageLabel.textAlignment = .center
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, ageLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 15
        labelStack.distribution = .equalSpacing
        
        self.view.addSubview(labelStack)
        
        labelStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        viewModel = ProfileViewModel()
        nameLabel.text = viewModel.userName
        ageLabel.text = "Age: \(viewModel.userAge)"
    }
    
    convenience init(viewModel: ProfileViewModel) {
        self.init()
        self.viewModel = viewModel
    }
}
