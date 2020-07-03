//
//  ForgotPasswordVC.swift
//  tutorialStripe
//
//  Created by 北島　志帆美 on 2020-06-29.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resetClicked(_ sender: UIButton) {
    
        guard let email = emailTxt.text, email.isNotEmpty else {
            simpleAlert(title: "Error", msg: "please enter email.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
