//
//  ChallengeLogInVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI & Nader Saffari on 5/13/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit
import QuartzCore

import FBSDKCoreKit
import FBSDKLoginKit

class ChallengeLogInVC: UIViewController, FBSDKLoginButtonDelegate, UINavigationBarDelegate {
    // MARK: Constands
    var fbLoginSuccess = false;
    let loggedIn = "LoggedIn"
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Properties
    let refUsers = Firebase(url: "https://fiery-inferno-5799.firebaseio.com/users")
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if (NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil) {
            self.performSegueWithIdentifier(self.loggedIn, sender: nil)
        
        }
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("Not logged in..")
        } else {
            print("logged in");
        }
        
        //facebook button programatically
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        // print("height:\(screenHeight/2), Width:\(screenWidth/2)")
        //loginButton.center = CGPoint(x: screenWidth/2, y: screenHeight/2)

        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        refUsers.observeAuthEventWithBlock { (authData) in
//            if (FBSDKAccessToken.currentAccessToken() != nil || self.fbLoginSuccess == true)
//            {
//                print("facebook logged already existing token!")
//                self.performSegueWithIdentifier(self.loggedIn, sender: self)
//            }
//        }
//    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.navigationController?.navigationBarHidden = true;
        refUsers.observeAuthEventWithBlock { (authData) in
            if (FBSDKAccessToken.currentAccessToken() != nil || self.fbLoginSuccess == true)
            {
                print("facebook logged already existing token!")
                self.performSegueWithIdentifier(self.loggedIn, sender: self)
            }
            if authData != nil {
                self.performSegueWithIdentifier(self.loggedIn, sender: nil)
            }
        }
    }
    
    // MARK: Facebook Login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil{
            fbLoginSuccess = true
            print("login complete")
        } else {
            print(error.localizedDescription);
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out...")
    }

    // MARK: Actions
    @IBAction func onLoginButtonPressed(sender: UIButton) {
        let email = textFieldLoginEmail.text
        let password = textFieldLoginPassword.text
        if email != "" && password != ""{
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) in
                if error != nil {
                    print(error.localizedDescription);
                    self.loginErrorAlert("Oops", message: error.localizedDescription)
                    
                } else {
                    // Be sure the correct uid is stored.
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    // Enter the app!
                    self.performSegueWithIdentifier(self.loggedIn, sender: nil)
                }
            })
        } else {
            loginErrorAlert("Oops", message: "Dont foget to enter your email")
        }
    }
        
    func loginErrorAlert(title: String, message: String) {
        
        // Called upon login error to let the user know login didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

