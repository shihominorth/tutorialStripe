//
//  extensions.swift
//  tutorialStripe
//
//  Created by 北島　志帆美 on 2020-06-27.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//


import UIKit
import Firebase

extension String {
    var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

