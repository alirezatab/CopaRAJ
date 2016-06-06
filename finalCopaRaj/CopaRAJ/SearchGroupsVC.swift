//
//  SearchGroupsVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/21/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

class SearchGroupsVC: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SearchResultCellDelegate {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var noResultsLabel: UILabel!
  
    @IBOutlet weak var joinChallange: UIButton!
  var groupsFromSearchResults : NSMutableArray?
  
  
  override func viewDidLoad() {
    self.activityIndicator.hidden = true
    self.groupsFromSearchResults = NSMutableArray()
    self.navigationController?.title = "Search For Challenges"
    //self.tableView.hidden = true
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    self.activityIndicator.hidden = false
    self.activityIndicator.startAnimating()
    self.activityIndicator.hidesWhenStopped = true
    self.groupsFromSearchResults = NSMutableArray()
    self.searchGroupsWith(searchBar.text!)
  }
  

  func searchGroupsWith(text:String) {
    let ref = DataService.dataService.CHALLENGEGROUPS_REF
    ref.queryOrderedByChild("name").queryStartingAtValue(text).queryLimitedToFirst(50).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) in
      if let newResults = snapshot.value as? NSDictionary {
        for (key, groupDictionary) in newResults {
          //print(groupDictionary)
          let newSearchResultGroup = SearchResultGroup()
          newSearchResultGroup.returnGroupWithResult(groupDictionary as! NSDictionary, groupID: key as! String)
          if ((newSearchResultGroup.name?.containsString(text)) == true){
          self.groupsFromSearchResults?.insertObject(newSearchResultGroup, atIndex: 0)
          } else {
            self.groupsFromSearchResults?.addObject(newSearchResultGroup)
            }

          //print(self.groupsFromSearchResults?.count)
        }
      }
        if (self.groupsFromSearchResults?.count < 1) {
            self.noResultsLabel.text = "No Result... Search Again"
            self.noResultsLabel.hidden = false
        } else {
            self.noResultsLabel.hidden = true
        }
      self.tableView.reloadData()
      self.activityIndicator.stopAnimating()
      
      }) { (error) in
        //print(error.localizedDescription)
        self.searchGroupsWith(text)
    }

   
  }
  

  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("groupHomeCell") as! SearchResultCell
    cell.delegate = self
    let challengeGroup = self.groupsFromSearchResults?.objectAtIndex(indexPath.row) as! SearchResultGroup
    cell.groupImageView.image = UIImage.init(named: challengeGroup.imageName!)
    if let createdBy = challengeGroup.createdBy as? String {
      cell.ptsLabel.text = "created by \(createdBy)"
    } else {
      cell.ptsLabel.text = ""
    }
    
    cell.groupNameLabel.text = challengeGroup.name as? String
    if challengeGroup.userIsAlreadyMember == true {
      cell.joinButton.enabled = false
      cell.joinButton.hidden = true
      cell.alreadyAMemberLabel.hidden = false
      cell.alreadyAMemberLabel.text = "Already A Member"
    } else {
      cell.joinButton.enabled = true
      cell.joinButton.hidden = false
        cell.joinButton.layer.cornerRadius = 5
        cell.joinButton.layer.masksToBounds = true
      cell.alreadyAMemberLabel.hidden = true
      if challengeGroup.members?.count > 14 {
        cell.joinButton.enabled = false
        cell.joinButton.hidden = true
        cell.alreadyAMemberLabel.text = "Group Limit Reached"
      }
    }
  
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.groupsFromSearchResults!.count
  }
  
  func userDidRequestJoin(sender: UIButton) {
    let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
    let indexPath = self.tableView.indexPathForRowAtPoint(hitPoint)
    let group = self.groupsFromSearchResults?.objectAtIndex((indexPath?.row)!) as! SearchResultGroup
    self.presentJoinGroup(group)
  }
  
  func presentJoinGroup(group: SearchResultGroup) {
    
    
    let alertController = UIAlertController(title: "Join \(group.name!)", message: "Please enter the password for \(group.name!)", preferredStyle: UIAlertControllerStyle.Alert)
    
    let enterPassword = UIAlertAction(title: "Enter", style: UIAlertActionStyle.Default, handler: {
      alert -> Void in
      
      let firstTextField = alertController.textFields![0] as UITextField
      //print(firstTextField.text)
      self.checkGroupPassword(group, password: firstTextField.text!)
    })
    
    alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
      textField.placeholder = "Enter Password"
    }
    let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
    
    alertController.addAction(cancel)
    alertController.addAction(enterPassword)
    
    
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  func checkGroupPassword (group : SearchResultGroup, password : String?) {
    if group.password != password {
      self.presentWrongPassword(group)
    } else {
      self.addUserToGroup(group)
    }
  }
  
  func presentWrongPassword(group : SearchResultGroup)  {
    let alert = UIAlertController(title: "Wrong Passowrd", message: "Please Try Again", preferredStyle: .Alert)
    let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(ok)
    self.presentViewController(alert, animated: true, completion: nil)
    
  }
  
  func addUserToGroup(group : SearchResultGroup) {
    //get ref to group
    
    let groupref = DataService.dataService.CHALLENGEGROUPS_REF.childByAppendingPath(group.uniqueID)
    groupref.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) in

      let firstName = NSUserDefaults.standardUserDefaults().valueForKey("firstName") as? String
      let lastName = NSUserDefaults.standardUserDefaults().valueForKey("lastName") as? String
      let newUsersListMember = groupref.childByAppendingPath(DataService.dataService.CURRENT_USER_REF.key)
      let userPickDetails = ["GroupAWinner": "", "GroupARunnerUP": "", "GroupAThirdPlace": "", "GroupAFourthPlace": "", "GroupBWinner": "", "GroupBRunnerUP": "", "GroupBThirdPlace": "", "GroupBFourthPlace": "", "GroupCWinner": "", "GroupCRunnerUP": "", "GroupCThirdPlace": "", "GroupCFourthPlace": "", "GroupDWinner": "", "GroupDRunnerUP": "", "GroupDThirdPlace": "", "GroupDFourthPlace": "", "SemifinalistTeam1":"", "SemifinalistTeam2":"", "SemifinalistTeam3":"", "SemifinalistTeam4":"", "FinalistTeam1": "", "FinalistTeam2":"", "Champion": "", "firstName":firstName! as String, "lastName": lastName! as String]
      
        newUsersListMember.setValue(userPickDetails)
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
  
  func presentAddedToGroup (group : SearchResultGroup) {
    let alert = UIAlertController(title: "Success", message: "You have been added to \(group.name!)", preferredStyle: .Alert)
    let ok = UIAlertAction(title: "OK", style: .Cancel) { (action) in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    alert.addAction(ok)
    self.presentViewController(alert, animated: true) { 
    }
    
    
  }
  
  func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
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






