//
//  SearchGroupsVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/21/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation
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


class SearchGroupsVC: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SearchResultCellDelegate {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var noResultsLabel: UILabel!
  
    @IBOutlet weak var joinChallange: UIButton!
  var groupsFromSearchResults : NSMutableArray?
  
  
  override func viewDidLoad() {
    self.activityIndicator.isHidden = true
    self.groupsFromSearchResults = NSMutableArray()
    self.navigationController?.title = "Search For Challenges"
    //self.tableView.hidden = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    self.activityIndicator.isHidden = false
    self.activityIndicator.startAnimating()
    self.activityIndicator.hidesWhenStopped = true
    self.groupsFromSearchResults = NSMutableArray()
    self.searchGroupsWith(searchBar.text!)
  }
  

  func searchGroupsWith(_ text:String) {
    let ref = DataService.dataService.CHALLENGEGROUPS_REF
    ref.queryOrdered(byChild: "name").queryStarting(atValue: text).queryLimited(toFirst: 50).observeSingleEvent(of: FEventType.value, with: { (snapshot) in
      if let newResults = snapshot?.value as? NSDictionary {
        for (key, groupDictionary) in newResults {
          //print(groupDictionary)
          let newSearchResultGroup = SearchResultGroup()
          newSearchResultGroup.returnGroupWithResult(groupDictionary as! NSDictionary, groupID: key as! String)
          if ((newSearchResultGroup.name?.contains(text)) == true){
          self.groupsFromSearchResults?.insert(newSearchResultGroup, at: 0)
          } else {
            self.groupsFromSearchResults?.add(newSearchResultGroup)
            }

          //print(self.groupsFromSearchResults?.count)
        }
      }
        if (self.groupsFromSearchResults?.count < 1) {
            self.noResultsLabel.text = "No Result... Search Again"
            self.noResultsLabel.isHidden = false
        } else {
            self.noResultsLabel.isHidden = true
        }
      self.tableView.reloadData()
      self.activityIndicator.stopAnimating()
      
      }) { (error) in
        //print(error.localizedDescription)
        self.searchGroupsWith(text)
    }

   
  }
  

  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "groupHomeCell") as! SearchResultCell
    cell.delegate = self
    let challengeGroup = self.groupsFromSearchResults?.object(at: indexPath.row) as! SearchResultGroup
    cell.groupImageView.image = UIImage.init(named: challengeGroup.imageName!)
    if let createdBy = challengeGroup.createdBy as? String {
      cell.ptsLabel.text = "created by \(createdBy)"
    } else {
      cell.ptsLabel.text = ""
    }
    
    cell.groupNameLabel.text = challengeGroup.name as? String
    if challengeGroup.userIsAlreadyMember == true {
      cell.joinButton.isEnabled = false
      cell.joinButton.isHidden = true
      cell.alreadyAMemberLabel.isHidden = false
      cell.alreadyAMemberLabel.text = "Already A Member"
    } else {
      cell.joinButton.isEnabled = true
      cell.joinButton.isHidden = false
        cell.joinButton.layer.cornerRadius = 5
        cell.joinButton.layer.masksToBounds = true
      cell.alreadyAMemberLabel.isHidden = true
      if challengeGroup.members?.count > 14 {
        cell.joinButton.isEnabled = false
        cell.joinButton.isHidden = true
        cell.alreadyAMemberLabel.text = "Group Limit Reached"
      }
    }
  
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.groupsFromSearchResults!.count
  }
  
  func userDidRequestJoin(_ sender: UIButton) {
    let hitPoint = sender.convert(CGPoint.zero, to: self.tableView)
    let indexPath = self.tableView.indexPathForRow(at: hitPoint)
    let group = self.groupsFromSearchResults?.object(at: (indexPath?.row)!) as! SearchResultGroup
    self.presentJoinGroup(group)
  }
  
  func presentJoinGroup(_ group: SearchResultGroup) {
    
    
    let alertController = UIAlertController(title: "Join \(group.name!)", message: "Please enter the password for \(group.name!)", preferredStyle: UIAlertControllerStyle.alert)
    
    let enterPassword = UIAlertAction(title: "Enter", style: UIAlertActionStyle.default, handler: {
      alert -> Void in
      
      let firstTextField = alertController.textFields![0] as UITextField
      //print(firstTextField.text)
      self.checkGroupPassword(group, password: firstTextField.text!)
    })
    
    alertController.addTextField { (textField : UITextField!) -> Void in
      textField.placeholder = "Enter Password"
    }
    let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
    
    alertController.addAction(cancel)
    alertController.addAction(enterPassword)
    
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func checkGroupPassword (_ group : SearchResultGroup, password : String?) {
    if group.password != password {
      self.presentWrongPassword(group)
    } else {
      self.addUserToGroup(group)
    }
  }
  
  func presentWrongPassword(_ group : SearchResultGroup)  {
    let alert = UIAlertController(title: "Wrong Passowrd", message: "Please Try Again", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
    
  }
  
  func addUserToGroup(_ group : SearchResultGroup) {
    //get ref to group
    
    let groupref = DataService.dataService.CHALLENGEGROUPS_REF.child(byAppendingPath: group.uniqueID)
    groupref?.observeSingleEvent(of: FEventType.value, with: { (snapshot) in

      let firstName = UserDefaults.standard.value(forKey: "firstName") as? String
      let lastName = UserDefaults.standard.value(forKey: "lastName") as? String
      let newUsersListMember = groupref?.child(byAppendingPath: DataService.dataService.CURRENT_USER_REF.key)
      let userPickDetails = ["GroupAWinner": "", "GroupARunnerUP": "", "GroupAThirdPlace": "", "GroupAFourthPlace": "", "GroupBWinner": "", "GroupBRunnerUP": "", "GroupBThirdPlace": "", "GroupBFourthPlace": "", "GroupCWinner": "", "GroupCRunnerUP": "", "GroupCThirdPlace": "", "GroupCFourthPlace": "", "GroupDWinner": "", "GroupDRunnerUP": "", "GroupDThirdPlace": "", "GroupDFourthPlace": "", "SemifinalistTeam1":"", "SemifinalistTeam2":"", "SemifinalistTeam3":"", "SemifinalistTeam4":"", "FinalistTeam1": "", "FinalistTeam2":"", "Champion": "", "firstName":firstName! as String, "lastName": lastName! as String]
      
        newUsersListMember?.setValue(userPickDetails)
        DataService.dataService.updateCurrentUserWithGroupID(group.uniqueID!, groupImage: group.imageName!, groupName: group.name as! String, createdBy: group.createdBy! as String, completionHandler: { (success) in
          if success == true {
            self.presentAddedToGroup(group)
            //print("success")
          } else if success == false {
            //print("fail")
          }
          })


      }) { (error) in
        
    }
    
  }
  
  func presentAddedToGroup (_ group : SearchResultGroup) {
    let alert = UIAlertController(title: "Success", message: "You have been added to \(group.name!)", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel) { (action) in
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(ok)
    self.present(alert, animated: true) { 
    }
    
    
  }
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return false
  }
//    let userID = groupref.childByAppendingPath(DataService.dataService.CURRENT_USER_REF.key)
//    
//    let firstName = NSUserDefaults.standardUserDefaults().valueForKey("firstName") as? String
//    let lastName = NSUserDefaults.standardUserDefaults().valueForKey("lastName") as? String
//    
//    let userPickDetails = ["GroupAWinner": "", "GroupARunnerUP": "", "GroupAThirdPlace": "", "GroupAFourthPlace": "", "GroupBWinner": "", "GroupBRunnerUP": "", "GroupBThirdPlace": "", "GroupBFourthPlace": "", "GroupCWinner": "", "GroupCRunnerUP": "", "GroupCThirdPlace": "", "GroupCFourthPlace": "", "GroupDWinner": "", "GroupDRunnerUP": "", "GroupDThirdPlace": "", "GroupDFourthPlace": "", "SemifinalistTeam1":"", "SemifinalistTeam2":"", "SemifinalistTeam3":"", "SemifinalistTeam4":"", "FinalistTeam1": "", "FinalistTeam2":"", "Champion": "", "firstName":firstName! as String, "lastName": lastName! as String]
//    
//    userID.setValue(userPickDetails)
//    DataService.dataService.updateCurrentUserWithGroupID(group.groupID, groupImage: <#T##String#>, groupName: <#T##String#>, createdBy: <#T##String#>, completionHandler: <#T##CompletionHandler##CompletionHandler##(success: Bool) -> Void#>)
    
//     DataService.dataService.updateCurrentUserWithGroupID(group.uniqueID!, groupImage: "Argentina", groupName: group.name as! String, createdBy: "\(firstName!) \(lastName!)", completionHandler: { (success) in},
}






