//
//  RecentMessageCell.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//
import Firebase
import UIKit

class RecentMessageCell: UITableViewCell {

        let timeLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .clear
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            return label
        }()
        
        let dateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .clear
            label.font = .systemFont(ofSize: 13, weight: .light)
            return label
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .clear
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            return label
        }()
          
        let messageLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .clear
            label.font = .systemFont(ofSize: 13, weight: .thin)
            return label
        }()
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            //imageView.setRoundedView(roundedView: imageView, toDiameter: 30)
            return imageView
        }()
         
        var message:Message?{
            didSet{
//                guard let friend = friend else { return }
//                profileImageView.image = UIImage(imageLiteralResourceName: "015-whale")
//                nameLabel.text = friend.name!
//                timeLabel.text = Date.twelveHourTimeString(date: Date())
//                dateLabel.text = Date.monthDayYear(date: Date())
//                mostRecentMessageLabel.text = friend.email!
            }
        }

        //add computed property once core data is init
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(profileImageView)
            addSubview(nameLabel)
            addSubview(timeLabel)
            addSubview(dateLabel)
            addSubview(messageLabel)
            
            let cellContraints = [
                profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
                profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                profileImageView.widthAnchor.constraint(equalToConstant: 50),
                profileImageView.heightAnchor.constraint(equalToConstant: 50),
                nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
                nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 30),
                
                timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
                timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
                
                dateLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -30),
                dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
                
                messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 30),
               messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
               messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -105),
            ]
            NSLayoutConstraint.activate(cellContraints)
        }
        
        required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
        }


}
