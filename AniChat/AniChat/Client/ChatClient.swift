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
    
    func messageForUser(results: @escaping ([String: Any])->Void){
        messageObserver() { message in
            //var user = DatabasePath.user(message.toId!).user
            var user = Database.database().reference().child(NodeConstant.messages).child(message.toId!)
            user.observeSingleEvent(of: .value) { snapshot in
                if let userInfo = snapshot.value as? [String: Any] {
                    var result: [String: Any]
                    result = userInfo
                    result["toId"] = (message.toId as! String)
                    result["fromId"] = (message.fromId as! String)
                    result["text"] = (message.text as! String)
                    result["date"] = (message.date as! Date)
                    result["incoming"] = (message.toId == Auth.auth().currentUser!.uid ? true : false)
                    results(result)
                }
            }
        }
    }
    
    func send(text: String, recipient: User){
        let date = Date()
        let messageInfo = ["toId": recipient.id, "fromId": Auth.auth().currentUser!.uid, "date": date.timeIntervalSince1970 as! NSNumber , "text": text] as [String : Any]
      Database.database().reference().child(NodeConstant.messages).childByAutoId().updateChildValues(messageInfo)
    }

}
