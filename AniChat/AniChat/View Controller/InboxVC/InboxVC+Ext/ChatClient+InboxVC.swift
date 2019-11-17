//
//  ChatClient+InboxVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit
extension InboxVC {
    
    func observeMessages(){
        chat.messageObserver(){ [weak self] message in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(message)
            strongSelf.tableView.reloadData()
            
            //not scrolling
            guard strongSelf.messages.count < 2 else { return }
            let indexPath = IndexPath(row:  strongSelf.messages.count-1, section: 0)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: (strongSelf.keyboardHeight ?? strongSelf.sendBarContainer.frame.size.height) + 40 , right: 0)
                        
            strongSelf.tableView.contentInset = insets
            strongSelf.tableView.scrollIndicatorInsets = insets
            strongSelf.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        
        }
    }
    
    func send(text: String){
        guard let contact = self.contact else { return }
        chat.send(text: text , recipient: contact)
        sendBarTF.text = ""
    }
}
