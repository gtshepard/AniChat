//
//  ChatClient+InboxVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension InboxVC {
    
    func observeMessages(){
//        chat.messageObserver(){ [weak self] message in
//            guard let strongSelf = self else { return }
//            strongSelf.messages.append(message)
//            strongSelf.tableView.reloadData()
//
//            //not scrolling
//            guard strongSelf.messages.count < 2 else { return }
//            let indexPath = IndexPath(row:  strongSelf.messages.count-1, section: 0)
//            let insets = UIEdgeInsets(top: 0, left: 0, bottom: (strongSelf.keyboardHeight ?? strongSelf.sendBarContainer.frame.size.height) + 40 , right: 0)
//
//            strongSelf.tableView.contentInset = insets
//            strongSelf.tableView.scrollIndicatorInsets = insets
//            strongSelf.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//
//        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded){[weak self] snapshot in
           // print(snapshot)
            guard let strongSelf = self else { return }
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value) { snapshot in
                print(snapshot)
                
                guard let messageInfo = snapshot.value as? [String: Any] else { return }
                let message = Message()
                message.toId = (messageInfo["toId"] as! String)
                message.fromId = (messageInfo["fromId"] as! String)
                message.text = (messageInfo["text"] as! String)
                let date = (messageInfo["date"] as! NSNumber)
                message.date = Date.init(timeIntervalSince1970: TimeInterval(truncating: date))
                strongSelf.messages.append(message)
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
    
    func send(text: String){
        guard let contact = self.contact else { return }
        chat.send(text: text , recipient: contact)
        sendBarTF.text = ""
    }
}
