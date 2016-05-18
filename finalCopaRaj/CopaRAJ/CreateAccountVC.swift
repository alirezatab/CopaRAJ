//
//  CreateAccountVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/15/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit
//import DataService

class CreateAccountVC: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let newUserLoggedIn = "NewUserLoggedIn"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                    self.signupErrorAlert("Oops", message: "Having some trouble creating your account. TRY AGAIN!")
                    print(error.localizedDescription)
                } else {
                    //create the username and password
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { (err, authData) in
                        
///                     let user = ["password": authData.provider!, "email": email!, "FirstName": firtstName!, "lastName": lastName!];
                        let user = ["provider": authData.provider!, "email": email!, "FirstName": firtstName!, "lastName": lastName!];
                        // Seal the deal in DataService.swift.
                        //DataService.dataService.createNewAccount(authData.uid, user: user)
                        DataService.dataService.createNewAccount(authData.uid, user: user);
                    })
                    //store the uid for future access - handy!
                    NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: "uid")
                    
                    //enter the app
                    self.performSegueWithIdentifier(self.newUserLoggedIn, sender: nil);
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
