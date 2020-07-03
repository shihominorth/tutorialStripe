//
//  Firebase+Utils.swift
//  tutorialStripe
//
//  Created by 北島　志帆美 on 2020-06-29.
//  Copyright © 2020 北島　志帆美. All rights reserved.
//

import Firebase


extension Firestore {
    
    var categories: Query {
        return collection("categories").order(by: "timeStamp")
    }
    
    func products(category: String) -> Query {
        return  collection("products")

        //        return collection("products").whereField("isActive", isEqualTo: true).order(by: "timeStamp", descending: true)
    }
}

extension Auth {
    
    func handleFireAuthError(error: Error, vc: UIViewController) {
           if let errorCode = AuthErrorCode(rawValue: error._code) {
               let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
               alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
           }
       }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
            
        default:
            return "Sorry, something went wrong."
        }
    }
    
}

