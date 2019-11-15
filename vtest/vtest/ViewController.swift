//
//  ViewController.swift
//  vtest
//
//  Created by Garrison Shepard on 11/15/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let photoClient = PhotoClient()
        photoClient.getPhotosByLocation()
    }
    
    
    //
    //  PhotoClient.swift
    //  virtualTourist
    //
    //  Created by Rafael-Levy  on 11/14/19.
    //  Copyright © 2019 udacity. All rights reserved.
    //

    import Foundation


    class PhotoClient {
        init() {}
        
        struct Coordinates {
            var longitude: String? = "-73.964531"
            var latitude: String? = "40.768215"
        }
        
        
        var coord: Coordinates = Coordinates()
        
        
        enum Endpoints {
            static let flickrBase = "https://api.flickr.com/services/rest"
            static let apiKey = "3fd609a720a4bb9593d561a44d79b427"
            static let responseFormat = "json"
            
            static let paramFormat = "format=\(Endpoints.responseFormat)"
            static let paramApiKey = "api_key=\(Endpoints.apiKey)"
           
            case getPhotos(Coordinates, Int)
            
            var stringValue: String {
                switch self {
                case .getPhotos(let coordinates, let page):
                    return Endpoints.flickrBase + "?" + Endpoints.paramApiKey + "&" + Endpoints.paramFormat + "&" + FlickrMethod.getPhotos.param + "&" + "lat=\(coordinates.latitude)&lon=\(coordinates.longitude)" + "&page=\(page)"
                }
            }
            
            var url: URL {
                return URL(string: self.stringValue)!
            }
        }
        
        enum FlickrMethod {
            case getPhotos
            
            var method: String {
                switch self {
                case .getPhotos:
                    return "flickr.photos.search"
                }
            }
            
            var param: String {
                return "method=\(method)"
            }
        }
        
        
        
        
        func getPhotosByLocation(_ lat:String, _ lon:String) {
            /*let urlString: String = "https://api.flickr.com/services/rest?api_key=3fd609a720a4bb9593d561a44d79b427&format=json& method=flickr.photos.search&lat=40.768215&lon=-73.964531&page=1"*/
            //let tempUrl = URL(string: Endpoints.url)
            var request = URLRequest(url: Endpoints.getPhotos(coord, 1).url)
            request.httpMethod = "GET"
            var task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        print(data, response)
                    }
                }
            }
            task.resume()
        }
        

    // URL
    // HTTP METHOD
    // URL_SESSION_CLASS
    //
        
        
        
    }



}

