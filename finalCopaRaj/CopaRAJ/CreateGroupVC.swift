//
//  CreateGroupVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/12/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
//fix cell for row for the groups home
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}




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
        
      self.finalizeButton.backgroundColor = UIColor.gray
      self.finalizeButton.setTitleColor(UIColor.white, for: UIControlState.disabled)
      self.title = "Create Challenge"
      self.finalizeButton.isEnabled = false
      self.activityIndicator.isHidden = true
      self.groupHelpLabel.isHidden = true
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
      self.groupHelpLabel.isHidden = true
      self.groupHelpLabel.text = ""
      self.finalizeButton.isEnabled = false
      self.finalizeButton.backgroundColor = UIColor.gray
    }
     //success
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 36 &&
      passwordConfirmationTextField.text?.characters.count > 4 &&
      passwordTextField.text == passwordConfirmationTextField.text
    {
      self.finalizeButton.isEnabled = true
      self.finalizeButton.backgroundColor = UIColor(red: 28.0/255.0, green: 205.0/255.0, blue: 3.0/255.0, alpha: 1)
      
      self.groupHelpLabel.isHidden = true
    }
      
      //group  name too lonh
    else if groupNameTextField.text?.characters.count > 35
    {
      self.groupHelpLabel.isHidden = false
      self.groupHelpLabel.text = "Group Name Too Long"
      self.finalizeButton.isEnabled = false
      self.finalizeButton.backgroundColor = UIColor.gray
    }
      
      //group name not entered
    else if groupNameTextField.text?.characters.count < 1
    {
      self.groupHelpLabel.isHidden = false
      self.groupHelpLabel.text = "Please enter a group name"
      self.finalizeButton.isEnabled = false
      self.finalizeButton.backgroundColor = UIColor.gray
    }
      //password is too short
    else if passwordTextField.text?.characters.count < 5 && passwordTextField.text?.characters.count > 0
    {
    
      self.groupHelpLabel.isHidden = false
      self.groupHelpLabel.text = "Password is too short"
      self.finalizeButton.isEnabled = false
      self.finalizeButton.backgroundColor = UIColor.gray
      
    }
      
      //confirmation not entered
    else if passwordTextField.text?.characters.count > 4 &&
      passwordConfirmationTextField.text == ""
    {
      
      self.groupHelpLabel.isHidden = false
      self.groupHelpLabel.text = "Please confirm the password"
      self.finalizeButton.isEnabled = false
      self.finalizeButton.backgroundColor = UIColor.gray
      
    }
      
      //passwords don't match
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 36 &&
      passwordTextField.text?.characters.count > 4 &&
      passwordTextField.text != passwordConfirmationTextField.text
    {
      
      self.groupHelpLabel.isHidden = false
      self.groupHelpLabel.text = "Passwords do not match"
      self.finalizeButton.isEnabled = false
      self.finalizeButton.backgroundColor = UIColor.gray
    }
    
    
    else if groupNameTextField.text?.characters.count > 0 &&
      groupNameTextField.text?.characters.count < 36 &&
      passwordTextField.text?.characters.count == 0 &&
      passwordConfirmationTextField.text?.characters.count == 0
    {
      
      self.groupHelpLabel.isHidden = true
      self.groupHelpLabel.text = ""
      self.finalizeButton.isEnabled = false
      self.finalizeButton.backgroundColor = UIColor.gray
    }

  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.checkIfFinalizeButtonShouldBeEnabled()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  @IBAction func onFinalizeButtonPressed(_ sender: AnyObject) {
    let newGroup = ChallengeGroup(name: self.groupNameTextField.text! as NSString, password: self.passwordTextField.text! as NSString, imageName: self.imageName!)
    self.activityIndicator.isHidden = false
    self.activityIndicator.startAnimating()
    self.createFireBaseGroup(newGroup)
    
  }
  
  func createFireBaseGroup(_ passedGroup: ChallengeGroup) {
    self.isUpdating = true
    self.checkIfFinalizeButtonShouldBeEnabled()
    let ref = DataService.dataService.CHALLENGEGROUPS_REF
    ref.queryOrdered(byChild: "name").queryEqual(toValue: passedGroup.name)
    .observeSingleEvent (of: FEventType.value, with: { (snapshot) in
      
      //print(snapshot.value)
      
      if (snapshot?.value) === NSNull() {
        
        let firstName = UserDefaults.standard.value(forKey: "firstName") as? String
        let lastName = UserDefaults.standard.value(forKey: "lastName") as? String
        
        let newFBGroup = ref.childByAutoId()
        let newGroupDetails = ["name": passedGroup.name!, "password": passedGroup.password!, "imageName": passedGroup.imageName!, "admin":DataService.dataService.CURRENT_USER_REF.key, "createdBy": "\(firstName! as String) \(lastName! as String)"] as [String : Any]
        newFBGroup?.setValue(newGroupDetails)
        
        let newUsersListFirstMember = newFBGroup?.child(byAppendingPath: DataService.dataService.CURRENT_USER_REF.key)
        
       
        let userPickDetails = ["GroupAWinner": "", "GroupARunnerUP": "", "GroupAThirdPlace": "", "GroupAFourthPlace": "", "GroupBWinner": "", "GroupBRunnerUP": "", "GroupBThirdPlace": "", "GroupBFourthPlace": "", "GroupCWinner": "", "GroupCRunnerUP": "", "GroupCThirdPlace": "", "GroupCFourthPlace": "", "GroupDWinner": "", "GroupDRunnerUP": "", "GroupDThirdPlace": "", "GroupDFourthPlace": "", "SemifinalistTeam1":"", "SemifinalistTeam2":"", "SemifinalistTeam3":"", "SemifinalistTeam4":"", "FinalistTeam1": "", "FinalistTeam2":"", "Champion": "", "firstName":firstName! as String, "lastName": lastName! as String]
        
        newUsersListFirstMember?.setValue(userPickDetails)
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
    let alert = UIAlertController(title: "This Group Name Already Exists", message: "Create a new name or go back to search for and join this group", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
    }
    alert.addAction(action)
    self.present(alert, animated: false, completion: nil)
  }
  
  func presentGroupSaveFailure() {
    let alert = UIAlertController(title: "Something went wrong when saving your information", message: "Please try again", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
    }
    alert.addAction(action)
    self.present(alert, animated: false, completion: nil)
  }
  
  func presentGroupCreated (_ group : ChallengeGroup) {
    let alert = UIAlertController(title: "Success", message: "\(group.name!) has been created", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel) { (action) in
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(ok)
    self.present(alert, animated: true) {
    }
  }
  
  
  @IBAction func onAvatarButtonPressed(_ sender: UIButton) {
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
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
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
