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
    
    enum DatabasePaths {
        static let database = Database.database().reference()
        static let users = database.child("users")
        static let myUid = Auth.auth().currentUser?.uid
        //case user(let uid)
        //case message
    }
     
    func fetchContacts(result: @escaping (User)->Void) {
        
      Database.database().reference().child("users").observe(.childAdded){ snapshot in
        
          if let userInfo = snapshot.value as? [String: Any] {
               let user = User()
               user.id = snapshot.key
               user.name = (userInfo["name"] as! String)
               user.email = (userInfo["email"] as! String)
               user.avatar = URL(string: (userInfo["avatarUrl"] as! String))
            
            if user.id != Auth.auth().currentUser?.uid{
                result(user)
            }
          }
      }
    }
    
    func contactObserver(result: @escaping (User)->Void) {
        DatabasePaths.users.observe(.childAdded) { snapshot in
            if snapshot.key != DatabasePaths.myUid {
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
}
