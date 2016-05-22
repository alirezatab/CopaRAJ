//
//  GroupHomeVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/14/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class GroupHomeVC: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource{
  
  var groups : NSMutableArray?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        self.groups = NSMutableArray()
        self.findGroupsForUser()
      
    }
  
  func findGroupsForUser() {
    let ref = DataService.dataService.CURRENT_USER_REF
    ref.queryOrderedByChild("groupID").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
     // print(snapshot.value)
    
      if (snapshot.value as? NSDictionary) != nil{
      
      for id in snapshot.value as! NSDictionary{
        let keyString = id.key as! String
        
        if keyString != "email" && keyString != "firstName" && keyString != "lastName" && keyString != "provider" {
//          print("Keystring = \(keyString) id.key = \(id.key) id.value = \(id.value)")
          let groupDictionary = id.value as! NSDictionary
          //print(groupDictionary)
          let groupID = groupDictionary.valueForKey("groupID") as! String
          let createdBy = groupDictionary.valueForKey("createdBy") as! String
          let groupImage = groupDictionary.valueForKey("groupImage") as! String
          let groupName = groupDictionary.valueForKey("groupName") as! String
          
          let newGroup = ChallengeGroup(name: groupName, imageName: groupImage, createdBy: createdBy, groupID: groupID)
          self.groups?.addObject(newGroup)

          
            if let groupDictionary = id.value as? NSDictionary{
                
              print(groupDictionary)
              let groupID = groupDictionary.valueForKey("groupID") as! String
              let createdBy = groupDictionary.valueForKey("createdBy") as! String
              let groupImage = groupDictionary.valueForKey("groupImage") as! String
              let groupName = groupDictionary.valueForKey("groupName") as! String
              
              let newGroup = ChallengeGroup(name: groupName, imageName: groupImage, createdBy: createdBy, groupID: groupID)
              self.groups?.addObject(newGroup)
         
            }
        }
        }
       
      }
      if self.groups?.count > 0 {
        self.tableView.reloadData()
      } else {
        self.createDefaultTableViewSettings()
      }
      }) { (error) in
        print(error.localizedDescription)
    }

    }
  
  func createDefaultTableViewSettings() {
    self.groups = NSMutableArray()
    let nonGroup = ChallengeGroup(name: "You're not in any groups", imageName: "Argentina", createdBy: "Join/Create a group to get in to the fun", groupID: "none")
    self.groups?.addObject(nonGroup)
    self.tableView.reloadData()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = self.groups?.count {
      return count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("groupHomeCell") as? GroupHomeCell
    let group = self.groups?.objectAtIndex(indexPath.row) as! ChallengeGroup
    
    if (group.name as? String) != nil {
      
    cell?.groupNameLabel.text = group.name as? String
    let pointsLabelText = "Created by \(group.createdBy!)"
    cell?.ptsLabel.text! = pointsLabelText
    cell?.groupImageView.image = UIImage.init(named: (group.imageName as? String)!)
    cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    return cell!
      
    }
    
    return cell!
  }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        if FBSDKAccessToken.currentAccessToken() == nil {
             DataService.dataService.CURRENT_USER_REF.unauth()
            // Remove the user's uid from storage
              NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
            //print("logged out from regular user account")
        } else {
            FBSDKAccessToken.currentAccessToken()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            //print("logged out from Facebook");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Remove the user's uid from storage
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
  }
  
  @IBAction func onSearchGroupsPressed(sender: AnyObject) {
    let shouldAllowSearch = self.checkDate()
    
    if shouldAllowSearch == true {
      self.performSegueWithIdentifier("searchGroups", sender: self)
    } else {
    self.cannotSearchGroups()
    }
    
  }
  @IBAction func onCreateNewGroupPressed(sender: AnyObject) {
    let shouldAllowNewGroup = self.checkDate()
    
    if shouldAllowNewGroup == true {
      self.performSegueWithIdentifier("CreateGroup", sender: self)
    } else {
      self.cannotSearchGroups()
    }
  }
  
  func checkDate() -> Bool {
    let date1 = NSDate()
    
    let dateString = "2016-06-07" // change to your date format
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date2 = dateFormatter.dateFromString(dateString)!
    
    //print("\(date1)  \(date2)")

    
    if date1.timeIntervalSinceReferenceDate > date2.timeIntervalSinceReferenceDate {
      return false
//      print("Date1 is Later than Date2")
    }
    else if date1.timeIntervalSinceReferenceDate <  date2.timeIntervalSinceReferenceDate {
      return true
//      print("Date1 is Earlier than Date2")
    }
    else {
      return false
//      print("Same dates")
    }
  }
  
  func cannotSearchGroups() {
    let alert = UIAlertController.init(title: "Oops", message: "Challenges can no longer be created or joined", preferredStyle: UIAlertControllerStyle.Alert)
    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "groupDetails" {
      let selectedGroup = self.groups?.objectAtIndex((self.tablevView.indexPathForCell(sender as! GroupHomeCell)?.row)!) as! ChallengeGroup
     let destVC = segue.destinationViewController as! GroupDetailsVC
      destVC.group = selectedGroup
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tablevView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
}