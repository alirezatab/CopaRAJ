//
//  CreateAccountVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/15/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit
//import DataService

class CreateAccountVC: UIViewController, UINavigationBarDelegate {

    //MARK: Segue Constant
    let newUserLoggedIn = "NewUserLoggedIn"
    
    //MARK: textField outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //MARK: button Outlets
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: Visual Effect outlets
    @IBOutlet weak var firstNameVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var lastNameVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var emailVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var passwordVisualEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameVisualEffectView.layer.cornerRadius = 5
        self.firstNameVisualEffectView.layer.masksToBounds = true
        self.firstNameTextField.backgroundColor = UIColor.clearColor()
        self.firstNameTextField.textColor = UIColor.whiteColor()
        self.firstNameTextField.attributedPlaceholder = NSAttributedString(string:"First Name",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        self.lastNameVisualEffectView.layer.cornerRadius = 5
        self.lastNameVisualEffectView.layer.masksToBounds = true
        self.lastNameTextField.backgroundColor = UIColor.clearColor()
        self.lastNameTextField.textColor = UIColor.whiteColor()
        self.lastNameTextField.attributedPlaceholder = NSAttributedString(string:"Last Name",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])

        
        self.emailVisualEffectView.layer.cornerRadius = 5
        self.emailVisualEffectView.layer.masksToBounds = true
        self.emailAddressTextField.backgroundColor = UIColor.clearColor()
        self.emailAddressTextField.textColor = UIColor.whiteColor()
        self.emailAddressTextField.attributedPlaceholder = NSAttributedString(string:"Email Adress",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])

        
        self.passwordVisualEffectView.layer.cornerRadius = 5
        self.passwordVisualEffectView.layer.masksToBounds = true
        self.passwordTextField.backgroundColor = UIColor.clearColor()
        self.passwordTextField.textColor = UIColor.whiteColor()
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        self.createButton.layer.cornerRadius = 5
        self.createButton.layer.masksToBounds = true
        
        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    

    @IBAction func createAccountButtonPressed(sender: AnyObject) {
        let firtstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        
        if firtstName != "" && lastName != "" && email != "" && password != ""{
            //set username and password
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
                if error != nil{
                    self.signupErrorAlert("Oops", message: error.localizedDescription)
                    print(error.localizedDescription)
                } else {
                    //create the username and password
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { (err, authData) in
                        
///                     let user = ["password": authData.provider!, "email": email!, "FirstName": firtstName!, "lastName": lastName!];
                        let user = ["provider": authData.provider!, "email": email!, "firstName": firtstName!, "lastName": lastName!];
                        // Seal the deal in DataService.swift.
                        //DataService.dataService.createNewAccount(authData.uid, user: user)
                        DataService.dataService.createNewAccount(authData.uid, user: user, completionHandler: { (success) in
                            if success == true {
                                //store the uid for future access - handy!
                                NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: "uid")
                                NSUserDefaults.standardUserDefaults().setValue(firtstName, forKey: "firstName")
                                NSUserDefaults.standardUserDefaults().setValue(lastName, forKey: "lastName")
                                
                                //enter the app
                                //self.performSegueWithIdentifier(self.newUserLoggedIn, sender: nil);
                                
                                self.performSegueWithIdentifier("unwindToLoginFromCreateUser", sender: self)

                            } else {
                                print(success)
                            }
                        })
                    })
                    
                }
            })

        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password and a username")
        }
    }
    
    func signupErrorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
