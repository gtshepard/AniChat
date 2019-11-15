//
//  LoginClient.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import Firebase

class LoginClient {
    
    enum DatabasePath {
        static let reference = Database.database().reference()
        static let users = reference.child("users")
        
        case user(String)
        
        var user: DatabaseReference {
            switch self {
            case .user(let uid):
                return DatabasePath.users.child(uid)
            }
        }
    }
    
    enum Account {
        static let reference = Auth.auth()
        static let myUid = reference.currentUser?.uid
        //case register(User)
    }
    
    func register(name: String, email: String, password: String, completion: @escaping ()-> Void) {
        
        Account.reference.createUser(withEmail: email , password: password) { authResult, error in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let userInfo = ["name": name, "email": email] as [String: Any]
            guard let myUid = Account.myUid else { return }
           
            let user = DatabasePath.user(myUid).user.updateChildValues(userInfo) { error, _ in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                completion()
            }
        }
    }
}
