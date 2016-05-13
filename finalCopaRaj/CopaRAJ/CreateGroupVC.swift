//
//  CreateGroupVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/12/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit


class CreateGroupVC: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var groupNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordConfirmationTextField: UITextField!
  @IBOutlet weak var finalizeButton: UIButton!

  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.finalizeButton.backgroundColor = UIColor.grayColor()
      self.finalizeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
      self.finalizeButton.enabled = false
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func checkIfGroupIsCreatable() {
    if groupNameTextField.text?.characters.count > 0 && groupNameTextField.text?.characters.count < 70 && passwordConfirmationTextField.text?.characters.count > 4 && passwordTextField.text == passwordConfirmationTextField.text {
      self.finalizeButton.enabled = true
      self.finalizeButton.backgroundColor = UIColor.greenColor()
    } else {
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()

    }
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    self.checkIfGroupIsCreatable()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  @IBAction func onFinalizeButtonPressed(sender: AnyObject) {
    let newGroup = ChallengeGroup(name: self.groupNameTextField.text!, password: self.passwordTextField.text!, imageName: "Argentina")
    
    
  }

}
