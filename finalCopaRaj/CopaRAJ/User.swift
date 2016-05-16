//
//  User.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/13/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class User: NSObject {
    let uid: String
    let email: String
    
    //initialize from Firebase
    init(authData: FAuthData){
        uid = authData.uid
        email = authData.providerData["email"] as! String
    }
    
    //Initialize from arbitrary data
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
