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
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
