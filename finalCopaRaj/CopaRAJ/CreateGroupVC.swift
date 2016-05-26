//
//  CreateGroupVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/12/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
//fix cell for row for the groups home
import UIKit



class CreateGroupVC: UIViewController, UITextFieldDelegate, UINavigationBarDelegate {
  @IBOutlet weak var groupNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordConfirmationTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var groupHelpLabel: UILabel!
  
  @IBOutlet weak var groupImage: UIImageView!
  
  
  @IBOutlet weak var finalizeButton: UIButton!
  
  var group : ChallengeGroup?
  var isUpdating : Bool?
  var imageName : String?
  
    override func viewDidLoad() {
      super.viewDidLoad()
        
    // Ali: hides white bar that shows on top of naagation Bar
    //self.navigationItem.hidesBackButton = true;
        
      self.finalizeButton.backgroundColor = UIColor.grayColor()
      self.finalizeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
      self.title = "Create Challenge"
      self.finalizeButton.enabled = false
      self.activityIndicator.hidden = true
      self.groupHelpLabel.hidden = true
      self.imageName = "avatar2"
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(CreateGroupVC.dismissKeyboard))
      self.view.addGestureRecognizer(tap)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func checkIfFinalizeButtonShouldBeEnabled() {
    //phone is updating web
    if self.isUpdating == true {
      self.groupHelpLabel.hidden = true
      self.groupHelpLabel.text = ""
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }
     //success
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 36 &&
      passwordConfirmationTextField.text?.characters.count > 4 &&
      passwordTextField.text == passwordConfirmationTextField.text
    {
      self.finalizeButton.enabled = true
      self.finalizeButton.backgroundColor = UIColor(red: 28.0/255.0, green: 205.0/255.0, blue: 3.0/255.0, alpha: 1)
      
      self.groupHelpLabel.hidden = true
    }
      
      //group  name too lonh
    else if groupNameTextField.text?.characters.count > 35
    {
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Group Name Too Long"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }
      
      //group name not entered
    else if groupNameTextField.text?.characters.count < 1
    {
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Please enter a group name"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }
      //password is too short
    else if passwordTextField.text?.characters.count < 5 && passwordTextField.text?.characters.count > 0
    {
    
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Password is too short"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
      
    }
      
      //confirmation not entered
    else if passwordTextField.text?.characters.count > 4 &&
      passwordConfirmationTextField.text == ""
    {
      
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Please confirm the password"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
      
    }
      
      //passwords don't match
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 36 &&
      passwordTextField.text?.characters.count > 4 &&
      passwordTextField.text != passwordConfirmationTextField.text
    {
      
      self.groupHelpLabel.hidden = false
      self.groupHelpLabel.text = "Passwords do not match"
      self.finalizeButton.enabled = false
      self.finalizeButton.backgroundColor = UIColor.grayColor()
    }
    
    
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 36 &&
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
    let newGroup = ChallengeGroup(name: self.groupNameTextField.text!, password: self.passwordTextField.text!, imageName: self.imageName!)
    self.activityIndicator.hidden = false
    self.activityIndicator.startAnimating()
    self.createFireBaseGroup(newGroup)
    
  }
  
  func createFireBaseGroup(passedGroup: ChallengeGroup) {
    self.isUpdating = true
    self.checkIfFinalizeButtonShouldBeEnabled()
    let ref = DataService.dataService.CHALLENGEGROUPS_REF
    ref.queryOrderedByChild("name").queryEqualToValue(passedGroup.name)
    .observeSingleEventOfType (FEventType.Value, withBlock: { (snapshot) in
      
      //print(snapshot.value)
      
      if (snapshot.value) === NSNull() {
        
        let firstName = NSUserDefaults.standardUserDefaults().valueForKey("firstName") as? String
        let lastName = NSUserDefaults.standardUserDefaults().valueForKey("lastName") as? String
        
        let newFBGroup = ref.childByAutoId()
        let newGroupDetails = ["name": passedGroup.name!, "password": passedGroup.password!, "imageName": passedGroup.imageName!, "admin":DataService.dataService.CURRENT_USER_REF.key, "createdBy": "\(firstName! as String) \(lastName! as String)"]
        newFBGroup.setValue(newGroupDetails)
        
        let newUsersListFirstMember = newFBGroup.childByAppendingPath(DataService.dataService.CURRENT_USER_REF.key)
        
       
        let userPickDetails = ["GroupAWinner": "", "GroupARunnerUP": "", "GroupAThirdPlace": "", "GroupAFourthPlace": "", "GroupBWinner": "", "GroupBRunnerUP": "", "GroupBThirdPlace": "", "GroupBFourthPlace": "", "GroupCWinner": "", "GroupCRunnerUP": "", "GroupCThirdPlace": "", "GroupCFourthPlace": "", "GroupDWinner": "", "GroupDRunnerUP": "", "GroupDThirdPlace": "", "GroupDFourthPlace": "", "SemifinalistTeam1":"", "SemifinalistTeam2":"", "SemifinalistTeam3":"", "SemifinalistTeam4":"", "FinalistTeam1": "", "FinalistTeam2":"", "Champion": "", "firstName":firstName! as String, "lastName": lastName! as String]
        
        newUsersListFirstMember.setValue(userPickDetails)
        DataService.dataService.updateCurrentUserWithGroupID(newFBGroup.key, groupImage: passedGroup.imageName!, groupName: passedGroup.name as! String, createdBy: "\(firstName!) \(lastName!)", completionHandler: { (success) in
          
              self.activityIndicator.stopAnimating()
              self.presentGroupCreated(passedGroup)
        })
      }
      else {
        self.activityIndicator.stopAnimating()
        self.presentAlertGroupAlreadyExists()
        self.isUpdating = false
        self.checkIfFinalizeButtonShouldBeEnabled()
      }
      }) { (NSError) in
        //print(NSError.description)
        self.presentGroupSaveFailure()
    }
  }
  
  func presentAlertGroupAlreadyExists() {
    let alert = UIAlertController(title: "This Group Name Already Exists", message: "Create a new name or go back to search for and join this group", preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel) { (action) in
    }
    alert.addAction(action)
    self.presentViewController(alert, animated: false, completion: nil)
  }
  
  func presentGroupSaveFailure() {
    let alert = UIAlertController(title: "Something went wrong when saving your information", message: "Please try again", preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel) { (action) in
    }
    alert.addAction(action)
    self.presentViewController(alert, animated: false, completion: nil)
  }
  
  func presentGroupCreated (group : ChallengeGroup) {
    let alert = UIAlertController(title: "Success", message: "\(group.name!) has been created", preferredStyle: .Alert)
    let ok = UIAlertAction(title: "OK", style: .Cancel) { (action) in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    alert.addAction(ok)
    self.presentViewController(alert, animated: true) {
    }
  }
  
  
  @IBAction func onAvatarButtonPressed(sender: UIButton) {
    let tag = sender.tag
    self.passwordTextField.resignFirstResponder()
    self.groupNameTextField.resignFirstResponder()
    self.passwordConfirmationTextField.resignFirstResponder()
    if tag == 2 {
      self.groupImage.image = UIImage.init(named: "avatar2")
      self.imageName = "avatar2"
    } else if tag == 1 {
      self.groupImage.image = UIImage.init(named: "avatar1")
      self.imageName = "avatar1"
    } else if tag == 7 {
      self.groupImage.image = UIImage.init(named: "avatar7")
      self.imageName = "avatar7"
    } else if tag == 5 {
      self.groupImage.image = UIImage.init(named: "avatar5")
      self.imageName = "avatar5"
    } else if tag == 4 {
      self.groupImage.image = UIImage.init(named: "avatar4")
      self.imageName = "avatar4"
    } else if tag == 6 {
      self.groupImage.image = UIImage.init(named: "avatar6")
      self.imageName = "avatar6"
    }
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let currentCharacterCount = textField.text?.characters.count ?? 0
    if (range.length + range.location > currentCharacterCount){
      return false
    }
    let newLength = currentCharacterCount + string.characters.count - range.length
    return newLength <= 35
    
  }
  
  func dismissKeyboard() {
    self.groupNameTextField.resignFirstResponder()
    self.passwordConfirmationTextField.resignFirstResponder()
    self.passwordTextField.resignFirstResponder()
    self.checkIfFinalizeButtonShouldBeEnabled()
  }
  

  
}
