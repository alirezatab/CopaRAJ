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
      for id in snapshot.value as! NSDictionary{
        let keyString = id.key as! String
        
        if keyString != "email" && keyString != "firstName" && keyString != "lastName" && keyString != "provider" {
//          print("Keystring = \(keyString) id.key = \(id.key) id.value = \(id.value)")
          
          let groupDictionary = id.value as! NSDictionary
          print(groupDictionary)
          let groupID = groupDictionary.valueForKey("groupID")
          
        }
      }
      }) { (error) in
        print(error.localizedDescription)
    }
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
    cell?.groupNameLabel.text = "testing"
    
    return cell!
  }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        // unauth() is the logout method for the current user
        DataService.dataService.CURRENT_USER_REF.unauth()
        
        // Remove the user's uid from storage
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
      

  }
}