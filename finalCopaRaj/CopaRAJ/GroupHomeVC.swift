//
//  GroupHomeVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/14/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class GroupHomeVC: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource{
  
  var groups : NSMutableArray?

  @IBOutlet weak var tablevView: UITableView!
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
          print(groupDictionary)
          let groupID = groupDictionary.valueForKey("groupID") as! String
          let createdBy = groupDictionary.valueForKey("createdBy") as! String
          let groupImage = groupDictionary.valueForKey("groupImage") as! String
          let groupName = groupDictionary.valueForKey("groupName") as! String
          
          let newGroup = ChallengeGroup(name: groupName, imageName: groupImage, createdBy: createdBy, groupID: groupID)
          self.groups?.addObject(newGroup)
          
        }
        }
        if self.groups?.count > 0 {
        self.tablevView.reloadData()
        } else {
          self.createDefaultTableViewSettings()
        }
      }
      }) { (error) in
        print(error.localizedDescription)
    }

    }
  
  func createDefaultTableViewSettings() {
    self.groups = NSMutableArray()
    let nonGroup = ChallengeGroup(name: "You're not in any groups", imageName: "Argentina", createdBy: "Join/Create a group to get in to the fun", groupID: "none")
    self.groups?.addObject(nonGroup)
    self.tablevView.reloadData()
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
    cell?.ptsLabel.text = "created by \(group.createdBy!)"
    cell?.groupImageView.image = UIImage.init(named: (group.imageName as? String)!)
    cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    return cell!
      
    }
    
    return cell!
  }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        // unauth() is the logout method for the current user
        DataService.dataService.CURRENT_USER_REF.unauth()
        
        // Remove the user's uid from storage
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
      

  }
}