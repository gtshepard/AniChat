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

    var messages :[Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recentMessageTV)
        fetchMessages()
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func logout() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showContacts(){
        let contactVC = ContactVC()
        contactVC.recentMessagesVC = self
        //let friendList = FriendsViewController()
        present(contactVC, animated: true, completion: nil)
    }
    
    func fetchMessages() {
        Database.database().reference().child("users").observe(.childAdded){ snapshot in
            if let user = snapshot.value as? [String: Any] {
              //append to table view data source 
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath) as? RecentMessageCell

        //cell?.friend = friends[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let friendMessengerViewController = FriendMessengerViewController()
//    friendMessengerViewController.friend = friends[indexPath.row]
//    navigationController?.pushViewController(friendMessengerViewController, animated: true)
    }
}
