//
//  CollectionViewCell.swift
//  TodoList
//
//  Created by 조규연 on 2023/09/15.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private var pictureImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawCell()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawCell()
    }
}

extension CollectionViewCell {
    
    private func drawCell() {
        pictureImageView = UIImageView()
        pictureImageView.clipsToBounds = true
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.frame = contentView.bounds
        
        contentView.addSubview(pictureImageView)
    }
    
    func configure(with image: UIImage) {
        pictureImageView.image = image
    }
}
