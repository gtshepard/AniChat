//
//  ContactMessageCell.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/23/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import UIKit

class ContactMessageCell: UICollectionViewCell {
   
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = "SAMPLE"
        textView.font = .systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        return textView
    }()
    
    static let blueColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
    
    let bubbleView: UIView = {
         let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
   
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        addSubview(bubbleView)
        addSubview(messageTextView)
        
        
        //x, y, w, h
        bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
//        bubbleWidthAnchor!.isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        //x, y, w, h
        messageTextView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        messageTextView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
