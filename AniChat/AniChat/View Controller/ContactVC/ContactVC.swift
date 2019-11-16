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
    var chat: ChatClient = ChatClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        
        observeContacts()
        view.addSubview(contactTV)
        
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
