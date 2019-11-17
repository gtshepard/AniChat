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
    
//    enum DatabasePath {
//        static let reference = Database.database().reference()
//        static let users = DatabasePath.reference.child("users")
//        static let messages = DatabasePath.reference.child("messages")
//
//
//
//
//
//    }
//    enum MessageMaker {
//        static let maker = DatabasePath.messages.childByAutoId()
//
//        case make([String : Any])
//
//        var message: Void {
//            switch self {
//            case .make(let messageInfo):
//                MessageMaker.maker.updateChildValues(messageInfo)
//                return
//            }
//        }
//    }
//
//
//    enum Account {
//        static let myUid = Auth.auth().currentUser?.uid
//    }
//
    func contactObserver(result: @escaping (User)->Void) {
        Database.database().reference().child("users").observe(.childAdded) { snapshot in
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
        Database.database().reference().child("messages").observe(.childAdded) { snapshot in
            if let dictonary = snapshot.value as? [String: Any] {
                let date = dictonary["date"] as! NSNumber
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
    
    func send(text: String, recipient: User){
        let date = Date()
        let messageInfo = ["toId": recipient.id, "fromId": Auth.auth().currentUser!.uid, "date": date.timeIntervalSince1970 as! NSNumber , "text": text] as [String : Any]
        Database.database().reference().child("messages").childByAutoId().updateChildValues(messageInfo)
    }
}
