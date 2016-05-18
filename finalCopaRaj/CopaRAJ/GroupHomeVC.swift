//
//  GroupHomeVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/14/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class GroupHomeVC: UIViewController, UINavigationBarDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;
    }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        // unauth() is the logout method for the current user
        DataService.dataService.CURRENT_USER_REF.unauth()
        
        // Remove the user's uid from storage
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        //segue ack to login Screen
//        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
//        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
