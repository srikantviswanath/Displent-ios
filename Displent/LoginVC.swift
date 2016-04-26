//
//  ViewController.swift
//  Displent
//
//  Created by Srikant Viswanath on 4/18/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func attemptToLogin(sender: UIButton!){
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != ""{
            DataService.dataService.REF_BASE.authUser(email, password: pwd){ error, authData in
                if error != nil{
                    if error.code == STATUS_USER_NONEXIST { //Attempt to create a new account and save in NsUserDefaults
                        DataService.dataService.REF_BASE.createUser(email, password: pwd){ error, result in
                            if error != nil {
                                self.showErrorMsg("Unable to create account", msg: "Error creating account.Please try something else")
                            }else{
                                print("RESULT RETURNED:\(result)")
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                DataService.dataService.REF_BASE.authUser(email, password: pwd, withCompletionBlock: nil)
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        }
                    }else{
                        self.showErrorMsg("Unable to login", msg: "Please ensure your email and password are correct")
                    }
                }else{
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                }
            }
        }else{
            showErrorMsg("Email/Password Required", msg: "Please enter an email and password to continue")
        }
    }
    
    func showErrorMsg(title: String!, msg: String!){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil{
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"]) { (fbResult: FBSDKLoginManagerLoginResult!, fbError: NSError!) in
            if fbError != nil {
                print("Facebook login failed. Error: \(fbError)")
            }else{
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                DataService.dataService.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil{
                        print("Login Failed:\(error)")
                    }else{
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }


}

