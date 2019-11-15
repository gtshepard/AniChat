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


}

