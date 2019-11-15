//
//  Ext+UIView.swift
//  AniChat
//
//  Created by Garrison Shepard on 11/14/19.
//  Copyright © 2019 Garrison. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func rounded(roundedView: UIView, toDiameter newSize: CGFloat) {
          let saveCenter: CGPoint = roundedView.center;
          let newFrame = CGRect(x: roundedView.frame.origin.x, y: roundedView.frame.origin.y, width: newSize, height: newSize)
          roundedView.frame = newFrame;
          roundedView.layer.cornerRadius = newSize / 2.0;
          roundedView.center = saveCenter;
      }
    
}
