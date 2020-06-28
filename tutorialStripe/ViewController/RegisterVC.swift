//
//  RegisterVC.swift
//  tutorialStripe
//
//  Created by 北島　志帆美 on 2020-06-27.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var comfirmPasswordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var passwordCheckImg: UIImageView!
    @IBOutlet weak var comfirmPasswordCheckImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        passwordTxt.addTarget(self, action: #selector(textDidChanged(_:)), for: UIControl.Event.editingChanged)
        comfirmPasswordTxt.addTarget(self, action: #selector(textDidChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textDidChanged(_ textField: UITextField) {
        guard let passwordText = textField.text else {
            return
        }
        
        if textField == comfirmPasswordTxt{
            passwordCheckImg.isHidden = false
            comfirmPasswordCheckImg.isHidden = false
        } else {
            passwordCheckImg.isHidden = true
            comfirmPasswordCheckImg.isHidden = true
            comfirmPasswordTxt.text = ""
        }
        
        
        if passwordTxt.text == comfirmPasswordTxt.text {
         
            passwordCheckImg.image = UIImage(named: AppImgs.greenCheck)
            comfirmPasswordCheckImg.image = UIImage(named: AppImgs.greenCheck)
            
        } else {
            passwordCheckImg.image = UIImage(named: AppImgs.redCheck)
            comfirmPasswordCheckImg.image = UIImage(named: AppImgs.redCheck)
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
        guard let emailText = emailTxt.text, emailText.isNotEmpty, let userName = userNameTxt.text, userName.isNotEmpty, let passwordText = passwordTxt.text, passwordText.isNotEmpty  else {
            return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText, completion: {(authResult, error) in
            
            if let error = error {
                debugPrint(error)
                return
            }
            
            self.activityIndicator.stopAnimating()
            
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


