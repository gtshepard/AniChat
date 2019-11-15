//
//  AvatarCell.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit

class AvatarCell: UICollectionViewCell {

    
    var avatarImageView: UIImageView?
    
    var avatar: String? {
        didSet {
        
            print("avatar: ", avatar)
            guard let avatar = avatar else { return }
            contentView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            contentView.rounded(roundedView: contentView, toDiameter: 20)
            let image = UIImage(imageLiteralResourceName: avatar)
            avatarImageView = UIImageView(image: image)
            guard let avatarImageView = avatarImageView else { return }
            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            avatarImageView.backgroundColor = .clear
            avatarImageView.rounded(roundedView: avatarImageView, toDiameter: 20)
            addSubview(avatarImageView)
            
           let avatarContraints = [
                  avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                     avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                  avatarImageView.heightAnchor.constraint(equalToConstant: 85),
                  avatarImageView.widthAnchor.constraint(equalToConstant: 85)
            ]
            NSLayoutConstraint.activate(avatarContraints)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView!.removeFromSuperview()
        self.contentView.layer.borderWidth = 0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.isSelected = false
    }
}
