//
//  InboxVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import UIKit
import Firebase

class InboxVC: UIViewController , UITableViewDelegate, UITableViewDataSource {

        let cellId = "id"
        var messages = [Message]()
        var keyboardHeight: CGFloat?
        var tableView: UITableView = UITableView()
        var bottomConstraintForInput: NSLayoutConstraint?
    
         //computed properties
        let sendBarContainer: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            return view
        }()
        
        let sendBarTF: UITextField = {
            let textField = UITextField()
            textField.backgroundColor = .white
            textField.placeholder = "Enter Message...."
            return textField
        }()
        
        let sendButton: UIButton = {
            let button = UIButton()
            button.setTitle("Send", for: .normal)
            let color = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha:1)
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            return button
        }()
        var contact: User?
        var chat: ChatClient = ChatClient()
    
        override func viewDidLoad() {
            
            super.viewDidLoad()
            navigationItem.title = contact!.name!
            setupTableView()
            view.addSubview(sendBarContainer)
            view.addConstraintsWithFormat("H:|[v0]|", views: sendBarContainer)
            view.addConstraintsWithFormat("V:[v0(48)]", views: sendBarContainer)
         
            bottomConstraintForInput = NSLayoutConstraint(item: sendBarContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
           
            view.addConstraint(bottomConstraintForInput!)
            sendBarTF.becomeFirstResponder()
            setupSendBar()
            
            //listen for keyboard events
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications), name: UIResponder.keyboardWillShowNotification , object: nil)
            
             observeMessages()
        }
 
        @objc func handleSendButtonTap() {
            if let msg = sendBarTF.text, !msg.isEmpty {
                send(text: msg)
            }
        }
        
        @objc func handleKeyboardNotifications(notification: NSNotification) {
            
            if let userInfo = notification.userInfo {
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                // get keyboard height
                bottomConstraintForInput?.constant = -keyboardFrame!.height
                keyboardHeight = keyboardFrame!.height
                
                //keyboard displays with animation
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                }) { [weak self] (completed) in
                        guard let strongSelf = self else { return }
                        //last item in table view sits above keyboard
                        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame!.height + 40, right: 0)
                        strongSelf.tableView.contentInset = insets
                        strongSelf.tableView.scrollIndicatorInsets = insets

                        if strongSelf.messages.isEmpty { return }
                        //scroll to bottom of tableview when keyboard showing
                        let indexPath = IndexPath(row: strongSelf.messages.count-1,
                        section: 0)
                        strongSelf.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                  }
             }
         }
        
        func setupTableView() {
            
            view.addSubview(tableView)
            //constraints
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            //settings
            tableView.allowsSelection = false
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            //prep
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
            tableView.reloadData()
        }
        
        func setupSendBar() {
            //setup message bar
            let topBorderView = UIView()
            topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            sendBarContainer.addSubview(sendBarTF)
            sendBarContainer.addSubview(sendButton)
            sendBarContainer.addSubview(topBorderView)
            sendButton.addTarget(self, action: #selector(handleSendButtonTap), for: .touchUpInside)
            
            sendBarContainer.addConstraintsWithFormat("H:|-8-[v0][v1(60)]|", views: sendBarTF, sendButton)
            sendBarContainer.addConstraintsWithFormat("V:|-8-[v0]|", views: sendBarTF)
            sendBarContainer.addConstraintsWithFormat("V:|-8-[v0]|", views: sendButton)
            sendBarContainer.addConstraintsWithFormat("H:|[v0]|", views: topBorderView)
            sendBarContainer.addConstraintsWithFormat("V:|[v0(0.5)]", views: topBorderView)
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return messages.count
        }

            
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as?
                MessageCell
                
                if let toId = messages[indexPath.row].toId {
                    let users = Database.database().reference().child("users").child(toId)
                    users.observeSingleEvent(of: .value) { snapshot in
                        if let dictionary = snapshot.value as? [String: Any]{
                            let name = dictionary["name"]! as! String
                            DispatchQueue.main.async {
                                cell?.recipient = name
                            }
                        }
                    }
                }
            
                if let userId = Auth.auth().currentUser?.uid {
                    let users = Database.database().reference().child("users").child(userId)
                    users.observeSingleEvent(of: .value) { snapshot in
                        if let dictionary = snapshot.value as? [String: Any]{
                            let name = dictionary["name"]! as! String
                            DispatchQueue.main.async {
                                print(name)
                                cell?.user = name
                            }
                        }
                    }
                }
               cell?.contact = contact
               cell?.message = messages[indexPath.row]
            return cell!
        }
}
