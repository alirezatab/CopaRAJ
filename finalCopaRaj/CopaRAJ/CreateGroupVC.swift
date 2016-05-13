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
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var groupHelpLabel: UILabel!
  
  
  var group : ChallengeGroup?
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.finalizeButton.backgroundColor = UIColor.grayColor()
      self.finalizeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
      self.finalizeButton.enabled = false
      self.activityIndicator.hidden = true
      self.groupHelpLabel.hidden = true
      
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func checkIfFinalizeButtonShouldBeEnabled() {
    
    if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 70 &&
      passwordConfirmationTextField.text?.characters.count > 4 &&
      passwordTextField.text == passwordConfirmationTextField.text
    {
      self.finalizeButton.enabled = true
      self.finalizeButton.backgroundColor = UIColor.greenColor()
      self.groupHelpLabel.hidden = true
    }
    else if groupNameTextField.text?.characters.count > 70
    {
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Group Name Too Long. Settle down there buddy"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }
    else if groupNameTextField.text?.characters.count < 1
    {
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Please enter a group name"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }
    else if passwordTextField.text?.characters.count < 5 && passwordTextField.text?.characters.count > 0
    {
    
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Password is too short"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
      
    }
    else if passwordTextField.text?.characters.count > 4 &&
      passwordConfirmationTextField.text == ""
    {
      
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Please confirm the password"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
      
    }
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 70 &&
      passwordConfirmationTextField.text?.characters.count > 4 &&
      passwordTextField.text != passwordConfirmationTextField.text
    {
      
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Passwords do not match"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }
    
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 70 &&
      passwordTextField.text?.characters.count > 4 &&
      passwordTextField.text != passwordConfirmationTextField.text
    {
      
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Passwords do not match"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }
    
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 70 &&
      passwordTextField.text?.characters.count == 0 &&
      passwordConfirmationTextField.text?.characters.count == 0
    {
      
      self.groupHelpLabel.hidden = true
      self.groupHelpLabel.text = ""
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }

  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    self.checkIfFinalizeButtonShouldBeEnabled()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  @IBAction func onFinalizeButtonPressed(sender: AnyObject) {
    let newGroup = ChallengeGroup(name: self.groupNameTextField.text!, password: self.passwordTextField.text!, imageName: "Argentina")
    self.activityIndicator.hidden = false
    self.activityIndicator.startAnimating()
    self.createFireBaseGroup(newGroup)
    
  }
  
  func createFireBaseGroup(passedGroup: ChallengeGroup) {
    let ref = Firebase (url: "https://fiery-inferno-5799.firebaseio.com/ChallengeGroups")
    ref.queryOrderedByChild("name").queryEqualToValue(passedGroup.name)
    .observeSingleEventOfType (FEventType.Value, withBlock: { (snapshot) in
      if (snapshot.value) is NSNull {
        
        let newFBGroup = ref.childByAutoId()
        let newGroupDetails = ["name": passedGroup.name!, "password": passedGroup.password!, "imageName": passedGroup.imageName!]
        newFBGroup.setValue(newGroupDetails)
        let groupId = newFBGroup.key
        print(groupId)
        ///!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!add groupID to user
      }
      else {
        self.presentAlertGroupAlreadyExists()
      }
      }) { (NSError) in
        print(NSError.description)
    }
  }
  
  func presentAlertGroupAlreadyExists() {
    let alert = UIAlertController(title: "This Group Name Already Exists", message: "Create a new name or go back to search for and join this group", preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel) { (action) in
    }
    alert.addAction(action)
    self.presentViewController(alert, animated: false, completion: nil)
  }
  
  func createGroupInFireBaseWithGroup(group: ChallengeGroup) {
    let ref = Firebase (url: "https://fiery-inferno-5799.firebaseio.com/ChallengeGroups")
    let newFBGroup = ref.childByAutoId()
    
    
    
  }

}
