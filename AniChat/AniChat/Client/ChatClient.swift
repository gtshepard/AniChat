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
    }
    
    enum UserPath {
        static let users = DatabasePath.reference.child("users")
        static let myUid = Auth.auth().currentUser?.uid
    }
     
    func contactObserver(result: @escaping (User)->Void) {
        UserPath.users.observe(.childAdded) { snapshot in
            if snapshot.key != UserPath.myUid {
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
