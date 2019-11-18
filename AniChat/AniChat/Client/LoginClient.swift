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
       
    enum NoError {
        case errorless(Error?)
        var errorless: Bool {
            switch self {
            case .errorless(let error):
                guard let err = error?.localizedDescription else { return true }
                print(err)
                return false
            }
        }
    }
    
    func register(name: String, email: String, password: String, avatar: String, completion: @escaping ()-> Void){
        
        let imageData = UIImage(imageLiteralResourceName: avatar).pngData()!
        let dataPath = Storage.storage().reference().child(avatar)
    
        dataPath.putData(imageData, metadata: nil) { [weak self] _, error in
            guard NoError.errorless(error).errorless else { return }
            guard let strongSelf = self else { return }
            dataPath.downloadURL() { url, error in
                guard NoError.errorless(error).errorless else { return }
                guard let avatarUrl = url else { return }
                print("URL: ", avatarUrl)
                strongSelf.register(name: name, email: email, password: password, avatarUrl: avatarUrl) {
                    completion()
                }
            }
        }
    }
    
    func register(name: String, email: String, password: String,avatarUrl: URL, complete: @escaping ()-> Void) {
        Auth.auth().createUser(withEmail: email , password: password) { authResult, error in
            guard NoError.errorless(error).errorless else { return }
            let userInfo = ["name": name, "email": email, "avatarUrl": (avatarUrl.absoluteString as String)] as [String: Any]
            guard let myUid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(myUid).updateChildValues(userInfo) { error, _ in
                guard NoError.errorless(error).errorless else { return }
                complete()
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (String?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(error?.localizedDescription)
                return
            }
            completion(nil)
        }
    }
    
    func logout(completion: @escaping ()->Void) {
        try! Auth.auth().signOut()
        completion()
    }
}
