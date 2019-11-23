//
//  Ext+ImageView.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/19/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit

let cache = NSCache<NSString, UIImage>()
var dataTask: URLSessionTask?
extension UIImageView {
    
    func loadImageUsingCache(urlString: String) {
        self.image = nil
        //check for cache
        if let cachedImage = cache.object(forKey: urlString as! NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let imageUrl = URL(string: urlString)!
        let session = URLSession.shared
        dataTask = session.dataTask(with: imageUrl) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                   cache.setObject(downloadedImage, forKey: urlString as! NSString)
                   strongSelf.image = downloadedImage
                }
            }
        }
        
        dataTask?.resume()
    }
    func cancelImageRequest() {
        guard let task = dataTask else { return }
        task.cancel()
    }
}
