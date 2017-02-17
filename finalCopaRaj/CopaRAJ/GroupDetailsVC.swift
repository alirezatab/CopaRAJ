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


class GroupDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
  var group :ChallengeGroup?
  var dateIsGood : Bool?
    
  override func viewDidLoad() {
    self.title = (self.group?.name as! String)
    self.navigationItem.hidesBackButton = true
    self.dateIsGood = self.checkDate()
    //self.navigationController?.navigationItem
    
  }

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.getGroupDetailsFromFirebase()
    }
  
  func getGroupDetailsFromFirebase() {
    let groupID = self.group?.groupID as! String
    let ref = Firebase(url: "https://fiery-inferno-5799.firebaseio.com/ChallengeGroups/\(groupID)")
    ref?.observeSingleEvent(of: FEventType.value, with: { (snapshot) in
      if let returnValue = snapshot?.value as? NSDictionary {
        
        let ref2 = DataService.dataService.BASE_REF.child(byAppendingPath: "ChallengeResults")
        ref2?.observe(FEventType.value, with: { (snapshot2) in
          if let tournyResults = snapshot2?.value as? NSDictionary {
            //print(tournyResults.valueForKey("Champion"))
          self.activityIndicator.stopAnimating()
          self.group?.updateGroupWithDictionary(returnValue, currentResults: tournyResults)
          let sortDescriptor = NSSortDescriptor(key: "points", ascending: false)
          let descriptors = [sortDescriptor]
          self.group?.members?.sort(using: descriptors)
          self.tableView.reloadData()
          }
          }, withCancel: { (error2) in
            //print(error2.localizedDescription)
        })
        
        
        
      } else {
        //print("wrong")
      }
      }) { (error) in
        
    }
  }
  
  
  @IBAction func onInviteFriendsPressed(_ sender: UIButton) {
    self.displayShareSheet()
  }
 
 
  
  func displayShareSheet() {
    let groupName = self.group?.name
    let password = self.group?.password
    let shareContent = "Downlaod Copa Club https://appsto.re/us/rhspcb.i and join my Copa Challenge \"\(groupName!)\". The password is \"\(password!)\""
    let shareSheet = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
    
    present(shareSheet, animated: true, completion: nil)
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0  {
      let cell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailsCell") as! GroupDetailsCell
      let shouldAllowSharing = self.shouldAllowSharing()
    cell.createdBy.text = "Created by \(self.group!.createdBy as! String) "

        if let password = self.group?.password {
     cell.groupPassword.text = "Password: \(password as String)"
        } else {
            cell.groupPassword.text = ""
        }
        
        cell.inviteButton.layer.cornerRadius = 5
        cell.inviteButton.layer.masksToBounds = true
        
        cell.makePicksButton.layer.cornerRadius = 5
        cell.makePicksButton.layer.masksToBounds = true
        
      if shouldAllowSharing == false {
        cell.inviteButton.isEnabled = false
        //cell.inviteButton.hidden = true
        cell.inviteButton.backgroundColor = UIColor.clear
        cell.inviteButton.tintColor = UIColor.clear
      } else {
        cell.inviteButton.isEnabled = true
        cell.inviteButton.isHidden = false
      }
      
      let shouldBeAllowedToStillMakePicks = self.checkDate()
      if shouldBeAllowedToStillMakePicks == false || self.group?.userHasMadePicks == true {
        cell.makePicksButton.isEnabled = false
        //cell.makePicksButton.hidden = true
        cell.makePicksButton.backgroundColor = UIColor.clear
        cell.makePicksButton.tintColor = UIColor.clear
      } else if shouldBeAllowedToStillMakePicks == true && self.group?.userHasMadePicks == false {
        cell.makePicksButton.isEnabled = true
        cell.makePicksButton.isHidden = false
      }
      return cell
    } else {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell") as! PlayerStandingCell
    let user = self.group?.members?.object(at: indexPath.row) as! ChallengeUser
    cell.playerLabel.text = "\(user.firstName!)  \(user.lastName!)"
    cell.ptsLabel.text = "\(user.points) pts"
      if self.group?.userHasMadePicks == true {
    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
      }
    return cell
    }
  }
  
  func shouldAllowSharing() -> Bool {
    let date1 = Date()
    
    let dateString = "2016-06-07" // change to your date format
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date2 = dateFormatter.date(from: dateString)!
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 50
        } else {
            return 100
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let screenBound = UIScreen.mainScreen().bounds
        //let screensize = screenBound.size
        //let screenwidth = screensize.width
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        
        let groupDetailsLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: self.view.frame.size.width / 2, height: 45))
        
        //CGRectMake(20, 5, screenwidth/2, 45)
        groupDetailsLabel.font = UIFont.init(name: "GothamMedium", size: 15)
        groupDetailsLabel.textColor = UIColor.init(white: 0.600, alpha: 1.000)
        groupDetailsLabel.textAlignment = NSTextAlignment.left
        
        headerView.backgroundColor = UIColor.init(white: 0.969, alpha: 1.000)//your background
        
        if section == 0 {
            groupDetailsLabel.text = "Challenge Details"
        } else {
            groupDetailsLabel.text = "Challenge Standings"
        }
        
        headerView.addSubview(groupDetailsLabel)
        
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section == 0 {
      return false
    } else if self.group?.userHasMadePicks == true {
      return true
    } else {
      return false
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section != 0 {
      self.performSegue(withIdentifier: "pickDetails", sender: indexPath)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "pickDetails" {
      let indexPath = sender as! IndexPath
      let user = self.group?.members?.object(at: indexPath.row) as! ChallengeUser
      let destVC = segue.destination as! PickDetailsVC
      destVC.member = user
    } else if segue.identifier == "makePicks" {
      let destVC = segue.destination as! PickGroupVC
      destVC.group = self.group
      //print(self.group!.name)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
  }
  
    
    
  @IBAction func unwindToGroupDetails(_ segue: UIStoryboardSegue) {
    
  }
  
  func checkDate() -> Bool {
    var returnVal = false
    let date1 = Date()
    
    let dateString = "2016-06-07" // change to your date format
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date2 = dateFormatter.date(from: dateString)!
    
    //print("\(date1)  \(date2)")
    
    
    if date1.timeIntervalSinceReferenceDate > date2.timeIntervalSinceReferenceDate {
      returnVal = false
      return returnVal
      //      print("Date1 is Later than Date2")
    }
    else if date1.timeIntervalSinceReferenceDate <  date2.timeIntervalSinceReferenceDate {
      returnVal = true
      return returnVal
      //      print("Date1 is Earlier than Date2")
    }
    else {
      returnVal = false
      return returnVal
      //      print("Same dates")
    }
  }

}
