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
    self.title = (self.group?.name as! String)
    self.activityIndicator.startAnimating()
    self.activityIndicator.hidesWhenStopped = true
    self.getGroupDetailsFromFirebase()
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
        //print("wrong")
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
      let shouldAllowSharing = self.shouldAllowSharing()
      if shouldAllowSharing == false {
        cell.inviteButton.enabled = false
        cell.inviteButton.hidden = true
      } else {
        cell.inviteButton.enabled = true
        cell.inviteButton.hidden = false
      }
      
      if self.group?.userHasMadePicks == true {
        cell.makePicksButton.enabled = false
        cell.makePicksButton.hidden = true
      } else {
        cell.makePicksButton.enabled = true
        cell.makePicksButton.hidden = false
      }
      return cell
    } else {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("playerCell") as! PlayerStandingCell
    let user = self.group?.members?.objectAtIndex(indexPath.row) as! ChallengeUser
    cell.playerLabel.text = "\(user.firstName!)  \(user.lastName!)"
    cell.ptsLabel.text = "\(user.points) pts"
    
    return cell
    }
  }
  
  func shouldAllowSharing() -> Bool {
    let date1 = NSDate()
    
    let dateString = "2016-06-07" // change to your date format
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date2 = dateFormatter.dateFromString(dateString)!
    
    if date1.timeIntervalSinceReferenceDate > date2.timeIntervalSinceReferenceDate {
      return false
      //      print("Date1 is Later than Date2")
    } else if self.group?.members?.count > 14 {
      return false
    }
    else if date1.timeIntervalSinceReferenceDate <  date2.timeIntervalSinceReferenceDate {
      return true
      //      print("Date1 is Earlier than Date2")
    }
    else {
      return false
      //      self.shareButton.enabled = false
      //      self.shareButton.tintColor = UIColor.clearColor()
      //      print("Same dates")
    }
  }
  
  func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if indexPath.section == 0 {
      return false
    } else {
      return true
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section != 0 {
      self.performSegueWithIdentifier("pickDetails", sender: indexPath)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "pickDetails" {
      let indexPath = sender as! NSIndexPath
      let user = self.group?.members?.objectAtIndex(indexPath.row) as! ChallengeUser
      let destVC = segue.destinationViewController as! PickDetailsVC
      destVC.member = user
    } else if segue.identifier == "makePicks" {
      let destVC = segue.destinationViewController as! PickGroupVC
      destVC.group = self.group
      
    }
  }
  

}
