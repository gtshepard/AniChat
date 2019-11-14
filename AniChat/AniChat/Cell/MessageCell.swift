//
//  MessageCell.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let containerView = UIView()
    let messageLabel = UILabel()
    let bubbleView = UIView()
    var nameLabel: UILabel?
    var avatarImageView: UIImageView?
    
    var messageTopConstraint: NSLayoutConstraint!
    var messageLeadingConstraint: NSLayoutConstraint?
    var messageTrailingConstraint: NSLayoutConstraint?
    var avatarLeadingConstraint: NSLayoutConstraint!
    var avatarTrailingConstraint: NSLayoutConstraint!

    var message: Message? {
        didSet {
            guard let message = message else { return }
            bubbleView.backgroundColor = message.incoming! ? .white : .darkGray
            messageLabel.textColor =  message.incoming! ? .black : .white
            
            messageLabel.text = message.text!
            
            if let photo = avatarImageView {
                photo.removeFromSuperview()
            }
            
            if let name = nameLabel {
                name.removeFromSuperview()
            }
            
            if let messageLeadingConstraint = messageLeadingConstraint {
                removeConstraint(messageLeadingConstraint)
            }
            
            if let messageTrailingConstraint = messageTrailingConstraint {
                removeConstraint(messageTrailingConstraint)
            }
            
            if let messageTopConstraint = messageTopConstraint {
                removeConstraint(messageTopConstraint)
            }
        
          //  if message.incoming! {
            //    if message.useProfile! {
                    
                    avatarImageView = UIImageView()
                    avatarImageView!.translatesAutoresizingMaskIntoConstraints = false
                    avatarImageView!.backgroundColor = .lightGray
                    avatarImageView!.image = UIImage(imageLiteralResourceName: "028-walrus")
                    avatarImageView!.clipsToBounds = true
                    //avatarImageView!.setRoundedView(roundedView: avatarImageView!, toDiameter: 30.0)
                    addSubview(avatarImageView!)
    
                    nameLabel = UILabel()
                    addSubview(nameLabel!)
                    nameLabel?.translatesAutoresizingMaskIntoConstraints = false
                    nameLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                    //nameLabel?.text =
                
                    let incomingMessageConstraints = [
                        avatarImageView!.topAnchor.constraint(equalTo: topAnchor , constant: 0),
                        avatarImageView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                        avatarImageView!.widthAnchor.constraint(equalToConstant: 60),
                        avatarImageView!.heightAnchor.constraint(equalToConstant: 60),
                        nameLabel!.topAnchor.constraint(equalTo: avatarImageView!.bottomAnchor, constant: 4),
                        nameLabel!.leadingAnchor.constraint(equalTo: avatarImageView!.trailingAnchor, constant: 0)
                    ]
                    
                    NSLayoutConstraint.activate(incomingMessageConstraints)
                    messageTopConstraint = messageLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 15)
                    messageLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: nameLabel!.leadingAnchor, constant: 15)
                
                    messageTopConstraint.isActive = true
                    messageLeadingConstraint!.isActive = true
                    messageTrailingConstraint!.isActive = false
                //}
//
//                } else {
//
//                    messageTopConstraint = messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
//                    messageLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 91)
//                    messageTrailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
//
//                    messageTopConstraint.isActive = true
//                    messageLeadingConstraint!.isActive = true
//                    messageTrailingConstraint!.isActive = false
//               }
//            } else {
//                messageTopConstraint = messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
//                messageTopConstraint.isActive = true
//                messageLeadingConstraint!.isActive = false
//                messageTrailingConstraint!.isActive = true
//            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                        
        backgroundColor = .clear
        addSubview(bubbleView)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = 8
                    
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
               
        let constraints = [
                //pushes label 16 from the contentView (the cell) never is long than 250px
                // messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 230),

                bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
                bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
                bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
                bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        messageTopConstraint = messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        messageLeadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        messageTrailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
