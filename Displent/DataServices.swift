//
//  DataServices.swift
//  Displent
//
//  Created by Srikant Viswanath on 4/20/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://displent.firebaseio.com"

class DataService {
    
    static let dataService = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase{
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase{
        return _REF_USERS
    }
    
    func createFirebaseUser(uid: String, userDict: Dictionary<String, String>){
        DataService.dataService.REF_USERS.childByAppendingPath(uid).setValue(userDict)
    }
    
    
}
