//
//  GroupHomeVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/14/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class GroupHomeVC: UIViewController, UINavigationBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;
    }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        // unauth() is the logout method for the current user
        if FBSDKAccessToken.currentAccessToken() == nil {
             DataService.dataService.CURRENT_USER_REF.unauth()
            // Remove the user's uid from storage
              NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
            print("logged out from regular user account")
        } else {
            FBSDKAccessToken.currentAccessToken()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            print("logged out from Facebook");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
