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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
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

