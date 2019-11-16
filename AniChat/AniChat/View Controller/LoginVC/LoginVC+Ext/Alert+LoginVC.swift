//
//  Alert+LoginVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
extension LoginVC {
    
    func forceUserToFullyRegister() {
        guard let username = nameTextField.text else { return }
                 print("user", username)
            
              guard username.count >= 3 else {
                  alert(message: "Enter Your Name")
                  return
              }
           
              guard let email = emailTextField.text else { return }
              
              print("email", email)
              guard email.count >= 4 else {
                  alert(message: "Enter Your Email")
                  return
              }
              
              guard email.contains("@") else {
                  alert(message: "Enter a Valid Email")
                  return
              }
              
              guard let password = passwordTextField.text else { return }
              print("pass:", password)
              guard password.count >= 6 else {
                  alert(message: "Enter a Password")
                  return
              }
    }
}
