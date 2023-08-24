//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by 조규연 on 2023/08/01.
//

import UIKit

// 커스텀 디자인 셀, 동적 콘텐츠 구현
class TodoTableViewCell: UITableViewCell {
    // 토글 스위치를 커스텀 셀에 만들었으니까 토글과 관련된 코드들은 여기에 작성하는게 좋을 것 같다.
    let toggleSwitch = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(toggleSwitch)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
