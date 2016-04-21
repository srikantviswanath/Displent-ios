//
//  DataServices.swift
//  Displent
//
//  Created by Srikant Viswanath on 4/20/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let dataService = DataService()
    
    private var _REF_BASE = Firebase(url: "https://displent.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    
    
}
