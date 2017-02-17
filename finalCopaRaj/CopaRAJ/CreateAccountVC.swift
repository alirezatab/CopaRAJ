//
//  CreateAccountVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/15/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit
//import DataService

class CreateAccountVC: UIViewController, UINavigationBarDelegate, UITextFieldDelegate {

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
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.dismissKeyboard))
      
      
      
      self.view.addGestureRecognizer(tap)
      
        self.firstNameVisualEffectView.layer.cornerRadius = 5
        self.firstNameVisualEffectView.layer.masksToBounds = true
        self.firstNameTextField.backgroundColor = UIColor.clear
        self.firstNameTextField.textColor = UIColor.black
        self.firstNameTextField.attributedPlaceholder = NSAttributedString(string:"First Name",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.lastNameVisualEffectView.layer.cornerRadius = 5
        self.lastNameVisualEffectView.layer.masksToBounds = true
        self.lastNameTextField.backgroundColor = UIColor.clear
        self.lastNameTextField.textColor = UIColor.black
        self.lastNameTextField.attributedPlaceholder = NSAttributedString(string:"Last Name",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])

        
        self.emailVisualEffectView.layer.cornerRadius = 5
        self.emailVisualEffectView.layer.masksToBounds = true
        self.emailAddressTextField.backgroundColor = UIColor.clear
        self.emailAddressTextField.textColor = UIColor.black
        self.emailAddressTextField.attributedPlaceholder = NSAttributedString(string:"Email Address",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])

        
        self.passwordVisualEffectView.layer.cornerRadius = 5
        self.passwordVisualEffectView.layer.masksToBounds = true
        self.passwordTextField.backgroundColor = UIColor.clear
        self.passwordTextField.textColor = UIColor.black
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        self.createButton.layer.cornerRadius = 5
        self.createButton.layer.masksToBounds = true
        
        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    

    @IBAction func createAccountButtonPressed(_ sender: AnyObject) {
        let firtstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        
        if firtstName != "" && lastName != "" && email != "" && password != ""{
            //set username and password
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
                if error != nil{
                    self.signupErrorAlert("ERROR", message: (error?.localizedDescription)!)
                    //print(error.localizedDescription)
                } else {
                    //create the username and password
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { (err, authData) in
                        
                        let user = ["provider": authData?.provider!, "email": email!, "firstName": firtstName!, "lastName": lastName!];
                        
                        DataService.dataService.createNewAccount(authData.uid, user: user, completionHandler: { (success) in
                            if success == true {
                                //store the uid for future access - handy!
                                UserDefaults.standard.setValue(result["uid"], forKey: "uid")
                                UserDefaults.standard.setValue(firtstName, forKey: "firstName")
                                UserDefaults.standard.setValue(lastName, forKey: "lastName")
                                
                                //enter the app
                                //self.performSegueWithIdentifier(self.newUserLoggedIn, sender: nil);
                                
                                self.performSegue(withIdentifier: "unwindToLoginFromCreateUser", sender: self)

                            } else {
                                //print(success)
                            }
                        })
                    })
                    
                }
            })

        } else {
            signupErrorAlert("Error", message: "Don't forget to enter your First Name, Last Name, Email Address and Password")
        }
    }
    
    func signupErrorAlert(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func dismissKeyboard() {
    self.firstNameTextField.resignFirstResponder()
    self.lastNameTextField.resignFirstResponder()
    self.emailAddressTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()
  }

}
