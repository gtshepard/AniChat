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
    
    enum DatabasePath {
        static let reference = Database.database().reference()
        static let users = DatabasePath.reference.child("users")
        static let messages = DatabasePath.reference.child("messages")
        
        case user(String)
        var user: DatabaseReference {
            switch self {
            case .user(let uid):
                return DatabasePath.users.child(uid)
            }
        }
    }
    enum MessageMaker {
        static let maker = DatabasePath.messages.childByAutoId()
        
        case make([String : Any])
        
        var message: Void {
            switch self {
            case .make(let messageInfo):
                MessageMaker.maker.updateChildValues(messageInfo)
                return
            }
        }
    }
    
    
    enum Account {
        static let myUid = Auth.auth().currentUser?.uid
    }
     
    func contactObserver(result: @escaping (User)->Void) {
        DatabasePath.users.observe(.childAdded) { snapshot in
            if snapshot.key != Account.myUid {
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
        DatabasePath.messages.observe(.childAdded) { snapshot in
            if let dictonary = snapshot.value as? [String: Any] {
                let date = dictonary["date"] as! NSNumber
                let message = Message()
                message.toId = dictonary["toId"] as! String
                message.fromId = dictonary["fromId"] as! String
                message.text = dictonary["text"] as! String
                message.date = Date.init(timeIntervalSince1970: TimeInterval(truncating: date))
                message.incoming = message.toId == Account.myUid ? true : false
                result(message)
            }
        }
    }
    
    func messageForUser(results: @escaping ([String: Any])->Void){
        messageObserver() { message in
            var user = DatabasePath.user(message.toId!).user
            user.observeSingleEvent(of: .value) { snapshot in
                if let userInfo = snapshot.value as? [String: Any] {
                    var result: [String: Any]
                    result = userInfo
                    result["toId"] = (message.toId as! String)
                    result["fromId"] = (message.fromId as! String)
                    result["text"] = (message.text as! String)
                    result["date"] = (message.date as! Date)
                    result["incoming"] = (message.toId == Account.myUid ? true : false)
                    results(result)
                }
            }
        }
    }
    
    func send(text: String, recipient: User){
        let date = Date()
        let messageInfo = ["toId": recipient.id, "fromId": Account.myUid, "date": date.timeIntervalSince1970 as! NSNumber , "text": text] as [String : Any]
        MessageMaker.make(messageInfo).message
    }
}
