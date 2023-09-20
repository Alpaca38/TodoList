//
//  ProfileView.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//

import UIKit
import SnapKit

class ProfileView: UIViewController {
    
    private var viewModel: UserViewModel!
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.view.backgroundColor = .white
        self.nameLabel.text = viewModel.userName
        self.ageLabel.text = String(viewModel.userAge)

        configure()
    }
}

private extension ProfileView {
    func configure() {
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, ageLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 15
        labelStack.distribution = .equalSpacing
        
        self.view.addSubview(labelStack)
        
        labelStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension ProfileView: UserViewModelDelegate {
    func updateUserName(name: String) {
        // 업데이트 작업은 메인 스레드에서 실행되어야 한다.
        DispatchQueue.main.async {
            self.nameLabel.text = name
        }
    }
    
    func updateUserAge(age: Int) {
        DispatchQueue.main.async {
            self.ageLabel.text = String(age)
        }
    }
}
