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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"]) { (fbResult: FBSDKLoginManagerLoginResult!, fbError: NSError!) in
            if fbError != nil {
                print("Facebook login failed. Error: \(fbError)")
            }else{
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged into Facebook -> \(accessToken)")
            }
        }
    }


}

