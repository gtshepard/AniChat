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
        //TODO: bug fix, login hit wuth a bad email email, button disables
        setupNavBar()
   
 
        chat.messagesForUserObserver() { [weak self] message in
            guard let strongSelf = self else { return }
           
            if message.toId! != Auth.auth().currentUser?.uid {
                guard let toId = message.toId else { return }
                strongSelf.messagesDictionary[toId] = message
                strongSelf.messages = Array(strongSelf.messagesDictionary.values)
                strongSelf.messages = strongSelf.messages.sorted { $0.date! > $1.date! }
                strongSelf.recentMessageTV.reloadData()
            }
        }
    }
    func setupNavBar() {
        login.fetchUserProfile() {[weak self] user in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.messagesDictionary.removeAll()
                strongSelf.messages.removeAll()
                strongSelf.recentMessageTV.reloadData()
                strongSelf.navigationItem.title = user.name
            }
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

//            guard let chatPartnerId = messages[indexPath.row].chatPartnerId() else { return }
//            let ref = Database.database().reference().child("users").child(chatPartnerId)
//            ref.observeSingleEvent(of: .value){ [weak self] snapshot in
//                print(snapshot)
//                guard let strongSelf = self else { return }
//                guard let  userInfo = snapshot.value as? [String: Any] else { return }
//                let user = User()
//                user.id = snapshot.key
//                user.name = (userInfo["name"] as! String)
//                user.email = (userInfo["email"] as! String)
//                user.avatar = URL(string: (userInfo["avatarUrl"] as! String))!
//                let inbox = InboxVC()
//                inbox.contact = user
//                inbox.user = user
//                strongSelf.navigationController!.pushViewController(inbox, animated: true)
//            }
           let inbox = ContactInboxVC(collectionViewLayout: UICollectionViewFlowLayout())
           navigationController!.pushViewController(inbox, animated: true)
    }
}
