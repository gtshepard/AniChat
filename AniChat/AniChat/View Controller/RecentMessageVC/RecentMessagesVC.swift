//
//  RecentMessagesVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import UIKit
import Firebase

class RecentMessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let recentMessageTV: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var messagesDictionary = [String: Message]()
    var messages :[Message] = []
    var login: LoginClient = LoginClient()
    var chat: ChatClient = ChatClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recentMessageTV)
        recentMessageTV.reloadData()
        
        let recentMessagesConstraints = [
            recentMessageTV.topAnchor.constraint(equalTo: view.topAnchor),
            recentMessageTV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentMessageTV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentMessageTV.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recentMessageTV.widthAnchor.constraint(equalTo: view.widthAnchor),
            recentMessageTV.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]

        NSLayoutConstraint.activate(recentMessagesConstraints)
        recentMessageTV.delegate = self
        recentMessageTV.dataSource = self
        recentMessageTV.register(RecentMessageCell.self, forCellReuseIdentifier: "ID")
        
        let newMessageImage = UIImage(imageLiteralResourceName: "new_message")
        let logoutImage = UIImage(imageLiteralResourceName: "logout")
       
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoutImage , style: .plain, target: self, action: #selector(logout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: .plain, target: self, action: #selector(showContacts))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
//        chat.messagesForUserObserver(){ message in
//
//        }
        
//        chat.messageObserver(){ [weak self] message in
//            guard let strongSelf = self else { return }
//
//            if let toId = message.toId {
//                strongSelf.messagesDictionary[toId] = message
//                strongSelf.messages = Array(strongSelf.messagesDictionary.values)
//            }
//
//            strongSelf.recentMessageTV.reloadData()
//        }
//        messages.removeAll()
//        messagesDictionary.removeAll()
//        recentMessageTV.reloadData()
        
//        chat.messagesForUserObserver() { [weak self] message in
////            print(message.toId!)
//            guard let strongSelf = self else { return }
//            if let toId = message.toId {
//                strongSelf.messagesDictionary[toId] = message
//                strongSelf.messages = Array(strongSelf.messagesDictionary.values)
//            }
//            strongSelf.recentMessageTV.reloadData()
//        }
            
        //TODO: bug fix, login hit wuth a bad email email, button disables
        
        messagesDictionary.removeAll()
        messages.removeAll()
        recentMessageTV.reloadData()
        userMessages()
        
    }
    
    
    func userMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Database.database().reference().child("user-messages").child(uid)
        reference.observe(.childAdded) { snapshot in
            print("user_message:", snapshot)
            
           let messageId = snapshot.key
           let messageReference = Database.database().reference().child("messages").child(messageId)
           messageReference.observeSingleEvent(of: .value, with: {[weak self] snap in
                print("Message: ", snap)
            guard let strongSelf = self else { return }
            if let dictonary = snap.value as? [String: Any] {
                let date = (dictonary["date"] as! NSNumber)
                let message = Message()
                
                message.toId = (dictonary["toId"] as! String)
                message.fromId = (dictonary["fromId"] as! String)
                message.text = (dictonary["text"] as! String)
                message.date = Date.init(timeIntervalSince1970: TimeInterval(truncating: date))
                message.incoming = message.toId == Auth.auth().currentUser?.uid ? true : false
                
                if let toId = message.toId {
                        strongSelf.messagesDictionary[toId] = message
                        strongSelf.messages = Array(strongSelf.messagesDictionary.values)
                        strongSelf.messages = strongSelf.messages.sorted { $0.date! > $1.date! }
                 }
                strongSelf.recentMessageTV.reloadData()
            }
          }, withCancel: nil)
        }
    }
     
    @objc func logout() {
        login.logout() { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func showContacts(){
        let contactVC = ContactVC()
        contactVC.recentMessagesVC = self
        //let friendList = FriendsViewController()
        present(contactVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath) as? RecentMessageCell

        cell?.message = messages[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let friendMessengerViewController = FriendMessengerViewController()
//    friendMessengerViewController.friend = friends[indexPath.row]
//    navigationController?.pushViewController(friendMessengerViewController, animated: true)
    }
}
