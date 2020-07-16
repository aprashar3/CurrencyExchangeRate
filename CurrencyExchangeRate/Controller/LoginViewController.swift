//
//  ViewController.swift
//  CurrencyExchangeRate
//
//  Created by 121outsource on 16/07/20.
//  Copyright © 2020 AshishKumar. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

 // Google Signin Methods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                 withError error: Error!) {
         if let error = error {
           if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
             print("The user has not signed in before or they have since signed out.")
           } else {
             print("\(error.localizedDescription)")
           }
           return
         }
         // Perform any operations on signed in user here.
         
        if UserDefaults.standard.value(forKey: "compareCurrency") != nil {
            self.performSegue(withIdentifier: "LoginToExchangeSegue", sender: nil)
        }else{
            self.performSegue(withIdentifier: "HomeCurrencySegue", sender: nil)
        }
    }
       
       func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                 withError error: Error!) {
         // Perform any operations when the user disconnects from app here.
         // ...
       }


}

