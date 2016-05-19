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
        
        ///facebook button programatically
        //loginButton.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textFieldLoginEmail.text = ""
        textFieldLoginPassword.text = ""
        
        refUsers.observeAuthEventWithBlock { (authData) in
            if (FBSDKAccessToken.currentAccessToken() != nil || self.fbLoginSuccess == true)
            {
                print("facebook logged already existing token!")
                self.performSegueWithIdentifier(self.loggedIn, sender: self)
            }
        }
    }
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated);
//        self.navigationController?.navigationBarHidden = false;
//        refUsers.observeAuthEventWithBlock { (authData) in
//            if (FBSDKAccessToken.currentAccessToken() != nil || self.fbLoginSuccess == true)
//            {
//                print("facebook logged already existing token!")
//                self.performSegueWithIdentifier(self.loggedIn, sender: self)
//            }
//            if authData != nil {
//                self.performSegueWithIdentifier(self.loggedIn, sender: nil)
//            }
//        }
//    }
    
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
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                if error != nil {
                    print(error.localizedDescription);
                    
                    self.displayErrorAlert("Oops", message: error.localizedDescription)
                    
                } else {
                    // Be sure the correct uid is stored
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    if ((DataService.dataService.CURRENT_USER_REF.authData.providerData["isTemporaryPassword"]?.boolValue)! == true){
                        print("Temp Pass was used")
                        self.displayChangePasswordAlert("Password Setup", message: "Please enter your new password", email: email!)
                    } else {
                        print("regular pass was used")
                    }
                    
                    // Enter the app!
                    self.performSegueWithIdentifier(self.loggedIn, sender: nil)
                }
            })
        } else {
            displayErrorAlert("Oops", message: "Dont foget to enter your email")
        }
    }
    
    @IBAction func forgottenPassword(sender: AnyObject) {
        
        var loginTextField: UITextField?
        let alertController = UIAlertController(title: "Password Recovery", message: "Please enter your email address", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if loginTextField?.text != "" {
                DataService.dataService.BASE_REF.resetPasswordForUser(loginTextField?.text, withCompletionBlock: { (error) in
                    if (error == nil) {
                        
                        self.displayErrorAlert("Password reset", message: "Check your inbox to reset your password")
                        
                    } else {
                        print(error)
                        self.displayErrorAlert("Unidentified email address", message:  "Please re-enter the email you registered with")
                    }
                })
            }
            print("textfield is empty")
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            loginTextField = textField
            loginTextField?.placeholder = "Enter your login ID"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func displayErrorAlert(title: String, message: String) {
        // Called upon login error to let the user know login didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayChangePasswordAlert(title: String, message: String, email: String) {
        var newPasswordTextField: UITextField?
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if newPasswordTextField?.text != "" {
                print(DataService.dataService.CURRENT_USER_REF.authData.auth["provider"])
                //DataService.dataService.CURRENT_USER_REF.setV
                DataService.dataService.BASE_REF.changePasswordForUser(email, fromOld: DataService.dataService.CURRENT_USER_REF.authData.provider , toNew: newPasswordTextField?.text, withCompletionBlock: { (error) in
                    if (error == nil) {
                        self.displayErrorAlert("New Password", message: "Pasword has been changed")
                    } else {
                        print(error)
                        //self.displayErrorAlert("Unidentified email address", message:  "Please re-enter the email you registered with")
                    }
                })
            }
            print("textfield is empty")
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newPasswordTextField = textField
            newPasswordTextField?.placeholder = "Enter new password"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    

    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

