//
//  ContactCell.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
      
    let emailLabel: UILabel = {
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
    

    var contact: User?{
        didSet{
            
            guard let contact = contact  else { return }
            nameLabel.text = contact.name!
            emailLabel.text = contact.email!
            
            let session = URLSession.shared
            var task = session.dataTask(with: contact.avatar!) {[weak self]data, response, error in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.profileImageView.image = UIImage(data: data!)
                }
            }
                   
            
                   task.resume()
       
            
            
            
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        
        let cellContraints = [
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 30),
    
            emailLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 30),
            emailLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -105),
        ]
        NSLayoutConstraint.activate(cellContraints)
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    
}
