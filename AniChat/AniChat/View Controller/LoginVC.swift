//
//  ViewController.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Firebase
import UIKit

class LoginVC: UIViewController {

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "name"
        return textField
    }()

    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "email@ios.com"
        return textField
    }()

    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        return textField
    }()

    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .lightGray
        button.contentHorizontalAlignment = .center
        //button.rounded(by:  5)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(loginOrRegister), for: .touchUpInside)
        return button
    }()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    lazy var loginSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Login", "Register"])
        segmentControl.backgroundColor = .lightGray
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 1
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: UIControl.State.selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        segmentControl.addTarget(self, action:#selector(handleToggle(_:)), for: .valueChanged)
        return segmentControl
    }()


    var navigationBar: UINavigationBar!
    var backgroundView: UIImageView!
    var stackView: UIStackView!

    var containerViewHeightConstraint: NSLayoutConstraint?
    var nameTextFieldHeightConstraint: NSLayoutConstraint?
    var emailTextFieldHeightConstraint: NSLayoutConstraint?
    var passwordTextFieldHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AniChat"

        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(containerView)
        view.addSubview(loginRegisterButton)

        containerView.addSubview(nameTextField)
        containerView.addSubview(nameSeparatorView)
        containerView.addSubview(emailTextField)
        containerView.addSubview(emailSeparatorView)
        containerView.addSubview(passwordTextField)

        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant:  -24).isActive = true
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 150)
        containerViewHeightConstraint?.isActive = true


        let loginRegisterButtonContraints = [
            loginRegisterButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12),
            loginRegisterButton.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(loginRegisterButtonContraints)

        let nameTextFieldContraints = [
            nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ]
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        NSLayoutConstraint.activate(nameTextFieldContraints)
        nameTextFieldHeightConstraint?.isActive = true

        let nameSepartorContraints = [
            nameSeparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -24),
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ]

        NSLayoutConstraint.activate(nameSepartorContraints)

        let emailTextFieldContraints = [
            emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ]
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)

        emailTextFieldHeightConstraint?.isActive = true
        NSLayoutConstraint.activate(emailTextFieldContraints)

        let emailSepartorContraints = [
            emailSeparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:  12 ),
            emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant:  -24),
            emailSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ]

        NSLayoutConstraint.activate(emailSepartorContraints)

        let passwordTextFieldContraints = [
            passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ]

        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightConstraint?.isActive = true
        NSLayoutConstraint.activate(passwordTextFieldContraints)

        view.addSubview(loginSegmentControl)
        let segmentConstraint = [
            loginSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginSegmentControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -130),
            loginSegmentControl.widthAnchor.constraint(equalTo: containerView.widthAnchor,multiplier:   3/4),
            loginSegmentControl.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(segmentConstraint)
    }

    @objc func loginOrRegister() {
        if loginSegmentControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) {[weak self] user, err in
            
            if err != nil {
                print(err)
                return
            }
            guard let strongSelf = self else { return }
            print("Login for: ", email, " Successful")
            let home = RecentMessagesVC()
            strongSelf.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    @objc func handleRegister() {
        guard let username = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
      

        Auth.auth().createUser(withEmail: email, password: password)
        { [weak self] authResult, err in
            guard let strongSelf = self else { return }
            if err != nil {
                print(err)
                return
            }
            
            print("Successfuly Authenticated User")
            guard let user = Auth.auth().currentUser else {return}
            let uid = user.uid

            let database = Database.database().reference()
            let userReference = database.child("users").child(uid)
            let values = ["name": username, "email": email]
            userReference.updateChildValues(values){ error, database in

                if error != nil {
                    print(error)
                    return
                }
                print("Registered User Succesfully")
                let home = RecentMessagesVC()
                strongSelf.navigationController?.pushViewController(home, animated: true)
            }
        }
    }
   
    @objc func handleToggle(_ sender: Any){
          let index = loginSegmentControl.selectedSegmentIndex
          let title = loginSegmentControl.titleForSegment(at: index)

          loginRegisterButton.setTitle(title, for: .normal)
          containerViewHeightConstraint?.constant = index == 0 ? 100:150

          nameTextFieldHeightConstraint?.isActive = false
          nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: index == 0 ? 0: 1/3)
          nameTextFieldHeightConstraint?.isActive = true

          nameSeparatorView.isHidden = index == 0 ? true : false

          emailTextFieldHeightConstraint?.isActive = false
          emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: index == 0 ? 1/2: 1/3)
          emailTextFieldHeightConstraint?.isActive = true

          passwordTextFieldHeightConstraint?.isActive = false
          passwordTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: index == 0 ? 1/2: 1/3)
          passwordTextFieldHeightConstraint?.isActive = true
      }
}

