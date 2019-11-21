//
//  Message.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import Firebase

class Message: NSObject {
     var toId: String?
     var fromId: String?
     var date: Date?
     var text: String?
     var incoming: Bool?
     var useProfile: Bool?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser!.uid ? toId : fromId
    }
    
}
