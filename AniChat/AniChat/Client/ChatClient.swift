//
//  ChatClient.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatClient {
    

    enum NodeConstant {
        static let users = "users"
        static let messages = "messages"
    }

    func contactObserver(result: @escaping (User)->Void) {
        Database.database().reference().child(NodeConstant.users).observe(.childAdded) { snapshot in
            if snapshot.key != Auth.auth().currentUser?.uid {
                if let userInfo = snapshot.value as? [String: Any] {
                    let user = User()
                    user.id = snapshot.key
                    user.name = (userInfo["name"] as! String)
                    user.email = (userInfo["email"] as! String)
                    user.avatar = URL(string: (userInfo["avatarUrl"] as! String))
                    result(user)
                }
            }
        }
    }
    
    func messageObserver(result: @escaping (Message)->Void) {
        Database.database().reference().child(NodeConstant.messages).observe(.childAdded) { snapshot in
            if let dictonary = snapshot.value as? [String: Any] {
                let date = (dictonary["date"] as! NSNumber)
                let message = Message()
                message.toId = (dictonary["toId"] as! String)
                message.fromId = (dictonary["fromId"] as! String)
                message.text = (dictonary["text"] as! String)
                message.date = Date.init(timeIntervalSince1970: TimeInterval(truncating: date))
                message.incoming = message.toId == Auth.auth().currentUser?.uid ? true : false
                result(message)
            }
        }
    }
    
    func messagesForUserObserver(results: @escaping ([String: Any])->Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Database.database().reference().child("user-messages").child(uid)
        reference.observe(.childAdded) { snapshot in
            print("user_message:", snapshot)
            
           let messageId = snapshot.key
           let messageReference = Database.database().reference().child("messages").child(messageId)
           messageReference.observeSingleEvent(of: .value, with: { snap in
                print("Message: ", snap)
          }, withCancel: nil)
            
        }
    
    }
    
    func send(text: String, recipient: User){
        let ref = Database.database().reference().child(NodeConstant.messages)
        let childRef = ref.childByAutoId()
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        let date = Date()
        let messageInfo = ["toId": recipient.id!, "fromId": Auth.auth().currentUser!.uid, "date": date.timeIntervalSince1970 as! NSNumber , "text": text] as [String : Any]
        
         childRef.updateChildValues(messageInfo) { error, _ in
            guard let messageId = childRef.key else { return }
        
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(recipient.id!).child(messageId)
                   recipientUserMessagesRef.setValue(1)
            }
        }
    }
