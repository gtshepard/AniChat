//
//  LoginClient+LoginVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit

extension LoginVC {
    
    @objc func loginOrRegister() {
        if loginSegmentControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @objc func handleRegister() {
          guard let username = nameTextField.text else { return }
          guard let email = emailTextField.text else { return }
          guard let password = passwordTextField.text else { return }
          forceUserToFullyRegister()
          
          guard let selectedProfileImage = self.didSelectProfile else { return }
          if selectedProfileImage {
              guard let avatarName = self.avatar else { return }
              loginClient.register(name: username, email: email, password: password, avatar: avatarName) { [weak self] in
                   guard let strongSelf = self else { return }
                   let home = RecentMessagesVC()
                   strongSelf.navigationController?.pushViewController(home, animated: true)
              }
          } else {
              alert(message: "Please Select An Avatar")
          }
      }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        loginClient.login(email: email, password: password) { [weak self] error in
            guard let strongSelf = self else { return }
            
            if error != nil {
                strongSelf.alert(message: "Invalid Username or Password")
                return
            }
            
            let home = RecentMessagesVC()
            strongSelf.navigationController?.pushViewController(home, animated: true)
        }
    }
}
