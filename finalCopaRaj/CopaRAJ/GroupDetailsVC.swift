//
//  GroupDetailsVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

//populate group with newest details
//need to know which user they are
//need to create array of users
//populate password field and share field
//have public ispassedlastjoindate


import Foundation

class GroupDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
  var group :ChallengeGroup?
  
  
  override func viewDidLoad() {
    self.checkDate()
    self.title = (self.group?.name as! String)
    self.activityIndicator.startAnimating()
    self.getGroupDetailsFromFirebase()
  }
  
  func checkDate() {
    let date1 = NSDate()
    
    let dateString = "2016-06-07" // change to your date format
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date2 = dateFormatter.dateFromString(dateString)!
    
    if date1.timeIntervalSinceReferenceDate > date2.timeIntervalSinceReferenceDate {
      //      self.shareButton.enabled = false
      //      self.shareButton.tintColor = UIColor.clearColor()
      //      print("Date1 is Later than Date2")
    }
    else if date1.timeIntervalSinceReferenceDate <  date2.timeIntervalSinceReferenceDate {
      //      print("Date1 is Earlier than Date2")
    }
    else {
      //      self.shareButton.enabled = false
      //      self.shareButton.tintColor = UIColor.clearColor()
      //      print("Same dates")
    }
  }
  
  func getGroupDetailsFromFirebase() {
    let groupID = self.group?.groupID as! String
    let ref = Firebase(url: "https://fiery-inferno-5799.firebaseio.com/ChallengeGroups/\(groupID)")
    ref.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) in
      if let returnValue = snapshot.value as? NSDictionary {
        self.activityIndicator.stopAnimating()
        self.group?.updateGroupWithDictionary(returnValue)
        self.tableView.reloadData()
        
      } else {
        print("wrong")
      }
      }) { (error) in
        
    }
  }
  
  
  @IBAction func onInviteFriendsPressed(sender: UIButton) {
    self.displayShareSheet()
  }
 
 
  
  func displayShareSheet() {
    let groupName = self.group?.name
    let password = self.group?.password
    let shareContent = "Downlaod Copa Club https://appsto.re/us/rhspcb.i and join my Copa Challenge \"\(groupName!)\". The password is \"\(password!)\""
    let shareSheet = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
    
    presentViewController(shareSheet, animated: true, completion: nil)
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      if let count = self.group?.members?.count {
        return count
      } else {
        return 0
      }
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0  {
      let cell = tableView.dequeueReusableCellWithIdentifier("GroupDetailsCell") as! GroupDetailsCell
      
      return cell
    } else {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("playerCell") as! PlayerStandingCell
    let user = self.group?.members?.objectAtIndex(indexPath.row) as! ChallengeUser
    cell.playerLabel.text = "\(user.firstName!)  \(user.lastName!)"
    cell.ptsLabel.text = "\(user.points) pts"
    
    return cell
    }
  }
  
  

}
