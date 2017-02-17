//
//  ChallengeLogInVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI
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
    //var fbID: String?
    
    var dict : NSDictionary!
    
    // MARK: Constands
    let loggedIn = "LoggedIn"
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        
        //add facebook login subview to the view
        self.view.addSubview(loginButton)
        loginButton.center = self.view.center
        loginButton.delegate = self
        
        self.textFieldLoginEmail.backgroundColor = UIColor.clear
        self.textFieldLoginEmail.textColor = UIColor.black
        self.textFieldLoginEmail.attributedPlaceholder = NSAttributedString(string:"Email",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        
        self.textFieldLoginPassword.backgroundColor = UIColor.clear
        self.textFieldLoginPassword.textColor = UIColor.black
        self.textFieldLoginPassword.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                               attributes:[NSForegroundColorAttributeName: UIColor.lightGray])

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
        //Ali testing
        if (UserDefaults.standard.value(forKey: "uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil) {
            self.performSegue(withIdentifier: self.loggedIn, sender: nil)
        }
      
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.navigationController?.isNavigationBarHidden = true
        
        textFieldLoginEmail.text = ""
        textFieldLoginPassword.text = ""
        
        if (UserDefaults.standard.value(forKey: "uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil) {
            self.performSegue(withIdentifier: self.loggedIn, sender: nil)
        }
    }
    
    // MARK: Facebook Login
    func fetchProfile() {
        //print("fetch Profile")
        if ((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.fbEmail = result["email"] as? String
                    self.fbFirstName = result["first_name"] as? String
                    self.fbLastName = result["last_name"] as? String
                    //self.fbID = result["id"] as? String
//                    print(self.fbEmail)
//                    print(self.fbFirstName)
//                    print(self.fbLastName)
                    //print(self.fbID)
                }
            })
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton?, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            //print(error.localizedDescription)
        } else if result.isCancelled{
            //print(result.isCancelled.description)
        } else {
            let token = FBSDKAccessToken.current().tokenString
            self.fetchProfile()
            DataService.dataService.BASE_REF.auth(withOAuthProvider: "facebook", token: token, withCompletionBlock: { (error, authData) in
                    
                if error != nil {
                    //print("login Failed")
                } else {
//                    print(self.fbEmail)
//                    print(self.fbFirstName)
//                    print(self.fbLastName)
                    let user: Dictionary<String, String> = ["provider": authData!.provider!, "email": self.fbEmail!, "firstName": self.fbFirstName!, "lastName": self.fbLastName!];//, "id": self.fbID!];
                        
                    DataService.dataService.createNewAccount(authData.uid, user: user, completionHandler: { (success) in
                            if success == true {
                                //store the uid for future access - handy!
                                UserDefaults.standard.setValue(authData.uid, forKey: "uid")
                                UserDefaults.standard.setValue(self.fbFirstName, forKey: "firstName")
                                UserDefaults.standard.setValue(self.fbLastName, forKey: "lastName")
                                //NSUserDefaults.standardUserDefaults().setValue(self.fbID, forKey: "id")
                                self.performSegue(withIdentifier: self.loggedIn, sender: nil)
                            } else {
                                //print(success)
                            }
                        })
                    }
                })
        }

    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //print("User logged out...")
    }

    // MARK: Actions
    @IBAction func onLoginButtonPressed(_ sender: UIButton) {
        let email = textFieldLoginEmail.text
        let password = textFieldLoginPassword.text
        if email != "" && password != ""{
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                if error != nil {
                    //print(error.localizedDescription);
                    
                    self.displayErrorAlert("Oops", message: (error?.localizedDescription)!)
                    
                } else {
                    // Be sure the correct uid is stored
                    UserDefaults.standard.setValue(authData?.uid, forKey: "uid")
                    
                    if (((DataService.dataService.CURRENT_USER_REF.authData.providerData["isTemporaryPassword"] as AnyObject).boolValue)! == true){
                        //print("Temp Pass was used")
                        self.displayChangePasswordAlert("Password Setup", message: "Please enter a new password", email: email!, oldPassword: password!)
                        self.textFieldLoginPassword.text = ""
                    } else {
                        //print("regular pass was used")
                        //print(authData.uid)
                        self.getUserNameFromFireBase((authData?.uid)!)
                        
                    }
                    // Enter the app!
                }
            })
        } else {
            displayErrorAlert("Oops", message: "Dont foget to enter your email")
        }
    }
    
    @IBAction func forgottenPassword(_ sender: AnyObject) {
        
        var loginTextField: UITextField?
        let alertController = UIAlertController(title: "Password Recovery", message: "Please enter your email address", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            if loginTextField?.text != "" {
                DataService.dataService.BASE_REF.resetPassword(forUser: loginTextField?.text, withCompletionBlock: { (error) in
                    if (error == nil) {
                        
                        self.displayErrorAlert("Password reset", message: "Check your inbox to reset your password")
                        
                    } else {
                        //print(error)
                        self.displayErrorAlert("Unidentified email address", message:  "Please re-enter the email you registered with")
                    }
                })
            }
            
            //print("textfield is empty")
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            loginTextField = textField
            loginTextField?.placeholder = "Enter your Email Address"
        }
        present(alertController, animated: true, completion: nil)
        
    }
    
    //Mark:- Helper Methods
    func getUserNameFromFireBase(_ uid: String) {
        let ref = DataService.dataService.USER_REF.child(byAppendingPath: uid)
        ref?.observe(FEventType.value, with: { (snapshot) in
            if let userInfo = snapshot?.value as? NSDictionary{
                let firstName = userInfo.value(forKey: "firstName")
                let lastName = userInfo.value(forKey: "lastName")
                UserDefaults.standard.setValue(uid, forKey: "uid")
                UserDefaults.standard.setValue(firstName, forKey: "firstName")
                UserDefaults.standard.setValue(lastName, forKey: "lastName")
                self.performSegue(withIdentifier: self.loggedIn, sender: nil)

            }
            }) { (error) in
                //print(error.localizedDescription)
        }
    }
    
    //MARK: Alerts
    func displayErrorAlert(_ title: String, message: String) {
        // Called upon login error to let the user know login didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func displayChangePasswordAlert(_ title: String, message: String, email: String, oldPassword: String) {
        var newPasswordTextField: UITextField?
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            if newPasswordTextField?.text != "" {

                DataService.dataService.BASE_REF.changePassword(forUser: email, fromOld: oldPassword, toNew: newPasswordTextField?.text, withCompletionBlock: { (error) in
                    if (error == nil) {
                        self.displayErrorAlert("New Password", message: "Pasword has been changed. Please re-enter your new password")
                    } else {
                        //print(error.localizedDescription)
                        self.displayErrorAlert("Error", message:  (error?.localizedDescription)!)
                    }
                })
            }
            //print("textfield is empty")
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            newPasswordTextField = textField
            newPasswordTextField?.placeholder = "Enter new password"
        }
        present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: textField work
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
    
    }
  
  func dismissKeyboard() {
    self.textFieldLoginEmail.resignFirstResponder()
    self.textFieldLoginPassword.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    self.navigationController?.isNavigationBarHidden = false
  }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
}
