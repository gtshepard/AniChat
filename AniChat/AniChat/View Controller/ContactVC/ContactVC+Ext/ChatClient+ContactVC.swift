//
//  ChatClient+ContactVC.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit

extension ContactVC {
    
    func observeContacts(){
        chat.contactObserver() { [weak self] user in
            guard let strongSelf = self else { return }
            strongSelf.contacts.append(user)
            strongSelf.contacts.sort { $0.name! < $1.name! }
            strongSelf.contactTV.reloadData()
  
        }
    }
}
