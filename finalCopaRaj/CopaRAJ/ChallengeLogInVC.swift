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

class ChallengeLogInVC: UIViewController, FBSDKLoginButtonDelegate, UINavigationBarDelegate, UITextFieldDelegate {
    
    //Facebook Login Button
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email", "user_friends"]
        return button
    }()
    
    // MARK: Variables
    var fbLoginSuccess = false;
    var fbUserInfo : NSMutableArray?
    var fbEmail : String?
    var fbFirstName : String?
    var fbLastName : String?
    var fbID: String?
    
    var dict : NSDictionary!
    
    // MARK: Constands
    let loggedIn = "LoggedIn"
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var emailVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var passwordVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var RegularLogin: UIButton!
    @IBOutlet weak var createNewAccountLogin: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    // MARK: Properties
    //let ref = Firebase(url: "https://fiery-inferno-5799.firebaseio.com/users")
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        
        //add facebook login subview to the view
        self.view.addSubview(loginButton)
        loginButton.center = self.view.center
        loginButton.delegate = self
        
        self.textFieldLoginEmail.backgroundColor = UIColor.clearColor()
        self.textFieldLoginEmail.textColor = UIColor.blackColor()
        self.textFieldLoginEmail.attributedPlaceholder = NSAttributedString(string:"Email",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        
        self.textFieldLoginPassword.backgroundColor = UIColor.clearColor()
        self.textFieldLoginPassword.textColor = UIColor.blackColor()
        self.textFieldLoginPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])

        self.emailVisualEffectView.layer.cornerRadius = 5
        self.emailVisualEffectView.layer.masksToBounds = true
        
        self.passwordVisualEffectView.layer.cornerRadius = 5
        self.passwordVisualEffectView.layer.masksToBounds = true
        
        self.RegularLogin.layer.cornerRadius = 5
        self.RegularLogin.layer.masksToBounds = true
        
        self.createNewAccountLogin.layer.cornerRadius = 5
        self.createNewAccountLogin.layer.masksToBounds = true
        
        self.forgotPassword.layer.cornerRadius = 5
        self.forgotPassword.layer.masksToBounds = true
      
       let tap = UITapGestureRecognizer(target: self, action: #selector(ChallengeLogInVC.dismissKeyboard))
      self.view.addGestureRecognizer(tap)

      
    }
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        self.navigationController?.navigationBarHidden = true
        
        textFieldLoginEmail.text = ""
        textFieldLoginPassword.text = ""
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil) {
            self.performSegueWithIdentifier(self.loggedIn, sender: nil)
        }
    }
    
    // MARK: Facebook Login
    func fetchProfile() {
        print("fetch Profile")
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.fbEmail = result["email"] as? String
                    self.fbFirstName = result["first_name"] as? String
                    self.fbLastName = result["last_name"] as? String
                    self.fbID = result["id"] as? String
                    print(self.fbEmail)
                    print(self.fbFirstName)
                    print(self.fbLastName)
                    print(self.fbID)
                }
            })
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton?, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            print(error.localizedDescription)
        } else if result.isCancelled{
            print(result.isCancelled.description)
        } else {
            let token = FBSDKAccessToken.currentAccessToken().tokenString
            self.fetchProfile()
            DataService.dataService.BASE_REF.authWithOAuthProvider("facebook", token: token, withCompletionBlock: { (error, authData) in
                    
                if error != nil {
                    print("login Failed")
                } else {
                    print(self.fbEmail)
                    print(self.fbFirstName)
                    print(self.fbLastName)
                    let user: Dictionary<String, String> = ["provider": authData.provider!, "email": self.fbEmail!, "firstName": self.fbFirstName!, "lastName": self.fbLastName!, "id": self.fbID!];
                        
                    DataService.dataService.createNewAccount(authData.uid, user: user, completionHandler: { (success) in
                            if success == true {
                                //store the uid for future access - handy!
                                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                                NSUserDefaults.standardUserDefaults().setValue(self.fbFirstName, forKey: "firstName")
                                NSUserDefaults.standardUserDefaults().setValue(self.fbLastName, forKey: "lastName")
                                NSUserDefaults.standardUserDefaults().setValue(self.fbID, forKey: "id")
                                self.performSegueWithIdentifier(self.loggedIn, sender: nil)
                            } else {
                                print(success)
                            }
                        })
                    }
                })
        }

    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
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
                        self.displayChangePasswordAlert("Password Setup", message: "Please enter a new password", email: email!, oldPassword: password!)
                        self.textFieldLoginPassword.text = ""
                    } else {
                        print("regular pass was used")
                        print(authData.uid)
                        self.getUserNameFromFireBase(authData.uid)
                        
                    }
                    // Enter the app!
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
            loginTextField?.placeholder = "Enter your Email Address"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //Mark:- Helper Methods
    func getUserNameFromFireBase(uid: String) {
        let ref = DataService.dataService.USER_REF.childByAppendingPath(uid)
        ref.observeEventType(FEventType.Value, withBlock: { (snapshot) in
            if let userInfo = snapshot.value as? NSDictionary{
                let firstName = userInfo.valueForKey("firstName")
                let lastName = userInfo.valueForKey("lastName")
                NSUserDefaults.standardUserDefaults().setValue(uid, forKey: "uid")
                NSUserDefaults.standardUserDefaults().setValue(firstName, forKey: "firstName")
                NSUserDefaults.standardUserDefaults().setValue(lastName, forKey: "lastName")
                self.performSegueWithIdentifier(self.loggedIn, sender: nil)

            }
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    //MARK: Alerts
    func displayErrorAlert(title: String, message: String) {
        // Called upon login error to let the user know login didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayChangePasswordAlert(title: String, message: String, email: String, oldPassword: String) {
        var newPasswordTextField: UITextField?
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if newPasswordTextField?.text != "" {

                DataService.dataService.BASE_REF.changePasswordForUser(email, fromOld: oldPassword, toNew: newPasswordTextField?.text, withCompletionBlock: { (error) in
                    if (error == nil) {
                        self.displayErrorAlert("New Password", message: "Pasword has been changed. Please re-enter your new password")
                    } else {
                        print(error.localizedDescription)
                        self.displayErrorAlert("Error", message:  error.localizedDescription)
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
    
    //Mark: textField work
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    
    }
  
  func dismissKeyboard() {
    self.textFieldLoginEmail.resignFirstResponder()
    self.textFieldLoginPassword.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    self.navigationController?.navigationBarHidden = false
  }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
}