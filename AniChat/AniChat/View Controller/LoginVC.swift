//
//  ViewController.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Firebase
import UIKit

class LoginVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
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
        button.rounded(roundedView: button , toDiameter: 20)
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

    let avatarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero , collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
     
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    let logoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.rounded(roundedView: imageView, toDiameter: 20)
        return imageView
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var navigationBar: UINavigationBar!
    var backgroundView: UIImageView!
    var stackView: UIStackView!

    var containerViewHeightConstraint: NSLayoutConstraint?
    var nameTextFieldHeightConstraint: NSLayoutConstraint?
    var emailTextFieldHeightConstraint: NSLayoutConstraint?
    var passwordTextFieldHeightConstraint: NSLayoutConstraint?

    var avatars: [String] = ["001-panda bear","002-dog","003-elephant","004-sheep", "005-fox", "006-crocodile", "007-llama", "008-zebra","009-horse", "010-snake","011-bear", "012-cat", "013-rhinoceros","014-sloth","015-whale","016-frog", "017-hippopotamus", "018-koala", "019-boar", "020-pig","021-guinea pig", "022-squirrel", "023-lemur", "024-duck", "025-monkey", "026-camel",
        "027-hen", "028-walrus", "029-mole", "030-mouse","031-buffalo", "032-cow","033-owl",
        "034-giraffe", "035-bat", "036-jaguar", "037-wolf"
        ,"038-chameleon", "039-ostrich", "040-rabbit", "041-lion", "042-eagle", "043-shark", "044-tiger",
         "045-raccoon", "046-anteater", "047-penguin", "048-beaver", "049-hedgehog", "050-kangaroo"
    ]
    
    var avatar: String?
    var avatarImage: UIImage?
    var didSelectProfile: Bool?
    var loginClient: LoginClient = LoginClient()
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
            loginSegmentControl.widthAnchor.constraint(equalTo: containerView.widthAnchor,multiplier: 1),
            loginSegmentControl.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(segmentConstraint)
        
        
        let horizontal = UICollectionViewFlowLayout()
        horizontal.scrollDirection = .horizontal
        horizontal.itemSize = CGSize(width: 90, height: 90)
        horizontal.minimumLineSpacing = CGFloat(exactly: 8.0)!
        horizontal.prepare()  // <-- call prepare before invalidateLayout
        horizontal.invalidateLayout()
        //avatarCollectionView
        avatarCollectionView.rounded(roundedView: avatarCollectionView, toDiameter: 20)
        avatarCollectionView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        avatarCollectionView.setCollectionViewLayout(horizontal, animated: true)
        avatarCollectionView.delegate = self
        avatarCollectionView.dataSource = self
        avatarCollectionView.backgroundColor = UIColor.lightGray

        view.addSubview(avatarCollectionView)
        let collectionConstraint = [
           avatarCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             avatarCollectionView.centerYAnchor.constraint(equalTo: loginSegmentControl.centerYAnchor, constant: -120),
           avatarCollectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
           avatarCollectionView.heightAnchor.constraint(equalToConstant: 140)
        ]
        
        NSLayoutConstraint.activate(collectionConstraint)
        avatarCollectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "id")
        setupLogo()
    }

    @objc func loginOrRegister() {
        if loginSegmentControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            cleanHandleRegister()
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
    @objc func cleanHandleRegister() {
        
        guard let username = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let selectedProfileImage = self.didSelectProfile else { return }
        
        if selectedProfileImage {
            guard let avatarName = self.avatar else { return }
            loginClient.registerWithPhoto(name: username, email: email, password: password, avatar: avatarName) { [weak self] in
                 guard let strongSelf = self else { return }
                 let home = RecentMessagesVC()
                 strongSelf.navigationController?.pushViewController(home, animated: true)
            }
        } else {
            //display alert select photo
            print("Please select a profile picture")
        }
        
        
    }
    @objc func handleRegister() {
        
        guard let username = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
      

        Auth.auth().createUser(withEmail: email, password: password)
        { authResult, err in
        
            if err != nil {
                print(err)
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("Successfuly Authenticated User")
      
            let dataStore = Storage.storage().reference().child(self.avatar!)
            guard let image = self.avatarImage,
                let selected = self.didSelectProfile else { return }
            
            if selected {
              
                guard let imageData =  image.pngData() else { return }
                dataStore.putData(imageData, metadata: nil) { metadata, error in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    print("metadata: ", metadata)
                
                    dataStore.downloadURL() { url, error in
                        
                        let values = ["name": username, "email": email, "avatarUrl": (url?.absoluteString as! String)] as [String: Any]
                       
                                print("Register")
                                let database = Database.database().reference()
                                let userReference = database.child("users").child(uid)

                                   userReference.updateChildValues(values) { error, database in
                                   if error != nil {
                                       print(error)
                                       return
                                   }
                                   
                                    let home = RecentMessagesVC()
                                    self.navigationController?.pushViewController(home, animated: true)
                    
                    
                                    }
                           }
                    }
            } else {
                print("Display alert to user ")
                return
            }
        
         
        }
    }
    
    private func registerUser(uid: String, userInfo: [String: Any]) {
        
        print("CALL REGISTER")
        let database = Database.database().reference()
        let userReference = database.child("users").child(uid)

            userReference.updateChildValues(userInfo) { error, database in
            if error != nil {
                print(error)
                return
            }
            
            print("Registered User Succesfully")
        }
           
    }
   
    func setupLogo() {
        view.addSubview(logoContainer)
        logoContainer.addSubview(logo)
        logoContainer.addSubview(logoLabel)
        logoContainer.backgroundColor = .lightGray
        logoContainer.isHidden = true
        logoContainer.rounded(roundedView: logoContainer, toDiameter: 20)
        logo.backgroundColor = .clear
        logo.isHidden = true
        logo.image = UIImage(imageLiteralResourceName: "024-duck")
        logoLabel.isHidden = true
        logoLabel.text = "Welcome"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 16)
        logoLabel.textColor = .white
        logoLabel.textAlignment = .center
        
        let logoConstraint = [
            logoContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoContainer.centerYAnchor.constraint(equalTo: loginSegmentControl.centerYAnchor, constant: -120),
            logoContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/2),
            logoContainer.heightAnchor.constraint(equalToConstant: 160),
            
            logo.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor, constant: -15),
            logo.widthAnchor.constraint(equalTo: logoContainer.widthAnchor, multiplier: 2/3),
            logo.heightAnchor.constraint(equalTo: logoContainer.heightAnchor, multiplier: 2/3),
          
            logoLabel.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor, constant: 60),
            logoLabel.widthAnchor.constraint(equalTo: logoContainer.widthAnchor, multiplier: 5/6),
            logoLabel.heightAnchor.constraint(equalTo: logoContainer.heightAnchor, multiplier: 1/6)
        ]
              
        NSLayoutConstraint.activate(logoConstraint)
        
        
    }
    
    @objc func handleToggle(_ sender: Any){
          let index = loginSegmentControl.selectedSegmentIndex
          let title = loginSegmentControl.titleForSegment(at: index)
          
          if index == 0 {
             avatarCollectionView.isHidden = true
            logoContainer.isHidden = false
            logo.isHidden = false
            logoLabel.isHidden = false
          } else {
             avatarCollectionView.isHidden = false
             logoContainer.isHidden = true
             logo.isHidden = true
             logoLabel.isHidden = true
          }
        
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
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return avatars.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath)
         as? AvatarCell
        
        didSelectProfile = false
        cell?.avatar = avatars[indexPath.row]
        return cell!
       }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        
        let collectoionCell = collectionView.cellForItem(at: indexPath) as? AvatarCell
        guard let cell = collectoionCell else { return }

        if cell.isSelected {
            print("im selected")
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.systemBlue.cgColor
            //guard let image = cell.avatarImageView?.image else { return }
            //avatarImage = image
            avatar = avatars[indexPath.row]
            didSelectProfile = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let collectionCell = collectionView.cellForItem(at: indexPath)
        guard let cell = collectionCell else { return }
        if !cell.isSelected {
              print("im Deselected")
              cell.contentView.layer.borderWidth = 0
              cell.contentView.layer.borderColor = UIColor.clear.cgColor
          }
    }
}

