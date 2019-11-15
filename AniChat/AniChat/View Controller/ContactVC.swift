//
//  ContactVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import UIKit
import Firebase

class ContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let contactTV: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var recentMessagesVC: RecentMessagesVC?
    var contacts :[User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.title = "Contacts"
        fetchContacts()
        view.addSubview(contactTV)
        contactTV.reloadData()
        
        let tableContraints = [
            contactTV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contactTV.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contactTV.widthAnchor.constraint(equalTo: view.widthAnchor),
            contactTV.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]

        NSLayoutConstraint.activate(tableContraints)
        contactTV.delegate = self
        contactTV.dataSource = self
        contactTV.register(ContactCell.self, forCellReuseIdentifier: "ID")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func fetchContacts() {
        Database.database().reference().child("users").observe(.childAdded){ [weak self] snapshot in
            guard let strongSelf = self else { return }
            if let user = snapshot.value as? [String: Any] {
                let contact = User()
                contact.id = snapshot.key
                contact.name = (user["name"] as! String)
                contact.email = (user["email"] as! String)
                contact.avatar = URL(string: (user["avatarUrl"] as! String))
                if snapshot.key != Auth.auth().currentUser?.uid {
                    strongSelf.contacts.append(contact)
                    strongSelf.contactTV.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath) as? ContactCell
        cell?.contact = contacts[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            let inbox = InboxVC()
            inbox.contact = strongSelf.contacts[indexPath.row]
            inbox.tableView.reloadData()
            strongSelf.recentMessagesVC!.navigationController?.pushViewController(inbox, animated: true)
            }
        }
}
