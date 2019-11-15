//
//  ChatClient.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit

class ChatClient {
    var image: UIImage?
    func requestAvatar(user: User) -> UIImage? {
        guard let url = user.avatar else { return nil }
        let session = URLSession.shared
  
        var task = session.dataTask(with: url) {data, response, error in
            if error != nil {
                print("ERRROR", error?.localizedDescription)
                return
            }
            
            guard let imageData = data else {
                print("NO URL")
                return
            }
            
            print("DATA: ", imageData)
            guard let response = response else {
                print("BAD REQUEST ")
                return
            }
            self.image = UIImage(data: imageData)
            print(response)
            
        }
        
 
        task.resume()
        return nil
    }
    
    
    
}
