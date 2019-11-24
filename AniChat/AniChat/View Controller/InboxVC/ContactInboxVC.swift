//
//  ContactInboxVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/23/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import UIKit
import Firebase
class ContactInboxVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let cellId = "cellId"
    var user: User? {
        didSet {
            guard let name = user?.name else { return }
            navigationItem.title = name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(ContactMessageCell.self, forCellWithReuseIdentifier: cellId)
        inputTextField.delegate = self
        setupInputComponents()
    }
  
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        
        //x, y , w, h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //send button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //text field
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter Message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //separator line
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
    
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    private func estimatedFrameForText(text: String) -> CGRect {
        //pcik a hieght valeu that is arbitrairly large
    //width of ContactMessage Cell
       let size = CGSize(width: 200, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
     
    @objc func handleSend(){
        print(inputTextField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.row].text {
            height = estimatedFrameForText(text: text).height + 40
        }
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
      }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ContactMessageCell
        let message = messages[indexPath.row]
        cell.messageTextView.text = message.text!
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 30
        return cell
    }
    
    
    func observeMessages(){
           guard let uid = Auth.auth().currentUser?.uid else { return }
           
           let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
           userMessagesRef.observe(.childAdded){[weak self] snapshot in
              // print(snapshot)
               guard let strongSelf = self else { return }
               let messageId = snapshot.key
               let messageRef = Database.database().reference().child("messages").child(messageId)
               messageRef.observeSingleEvent(of: .value) { snapshot in
                   guard let messageInfo = snapshot.value as? [String: Any] else { return }
                   let message = Message()
                   message.toId = (messageInfo["toId"] as! String)
                   message.fromId = (messageInfo["fromId"] as! String)
                   message.text = (messageInfo["text"] as! String)
                   let date = (messageInfo["date"] as! NSNumber)
                   message.date = Date.init(timeIntervalSince1970: TimeInterval(truncating: date))
                   if message.chatPartnerId() == strongSelf.user?.id {
                       print(message)
                       strongSelf.messages.append(message)
                           DispatchQueue.main.async {
                           strongSelf.collectionView.reloadData()
                       }
                   }
                 
               }
           }
       }
}
