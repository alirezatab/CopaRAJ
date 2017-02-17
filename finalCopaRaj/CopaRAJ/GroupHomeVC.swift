//
//  GroupHomeVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/14/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
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


class GroupHomeVC: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource{
  
  var groups : NSMutableArray?
  var didAlreadySearchGroups : Bool?
  var isMemberOfGroups :Bool?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var joinChallange: UIButton!
    @IBOutlet weak var createChallange: UIButton!
    
    
    
  override func viewWillAppear(_ animated: Bool) {
    if self.didAlreadySearchGroups != true {
    self.findGroupsForUser()
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        self.didAlreadySearchGroups = true
        self.findGroupsForUser()
        self.navigationController?.isNavigationBarHidden = false
        
        self.joinChallange.layer.cornerRadius = 5
        self.joinChallange.layer.masksToBounds = true
        
        self.createChallange.layer.cornerRadius = 5
        self.createChallange.layer.masksToBounds = true
    }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.didAlreadySearchGroups = false
  }
  
  func findGroupsForUser() {
    self.groups = NSMutableArray()
    let ref = DataService.dataService.CURRENT_USER_REF
    ref.queryOrdered(byChild: "groupID").observeSingleEvent(of: .value, with: { (snapshot) in
     // print(snapshot.value)
    
      if (snapshot?.value as? NSDictionary) != nil{
      
      for id in snapshot?.value as! NSDictionary{
      
          if let groupDictionary = id.value as? NSDictionary{

            //print(snapshot.value)
            let groupID = groupDictionary.value(forKey: "groupID") as! String
            let createdBy = groupDictionary.value(forKey: "createdBy") as! String
            let groupImage = groupDictionary.value(forKey: "groupImage") as! String
            let groupName = groupDictionary.value(forKey: "groupName") as! String
              
            let newGroup = ChallengeGroup(name: groupName as NSString, imageName: groupImage, createdBy: createdBy as NSString, groupID: groupID as NSString)
            //print(newGroup.imageName)
            self.groups?.add(newGroup)
         
            }
        }
        }
       
      if self.groups?.count > 0 {
        self.isMemberOfGroups = true
        self.tableView.reloadData()
        self.tableView.isUserInteractionEnabled = true
      } else {
        self.isMemberOfGroups = false
        self.createDefaultTableViewSettings()
      }
      }) { (error) in
        //print(error.localizedDescription)
    }

    }
  
  func createDefaultTableViewSettings() {
    self.groups = NSMutableArray()
    let nonGroup = ChallengeGroup(name: "You're not in any challenges", imageName: "", createdBy: "Join or create a challenge below!", groupID: "none")
    self.groups?.add(nonGroup)
    self.tableView.reloadData()
    self.tableView.isUserInteractionEnabled = false
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = self.groups?.count {
      return count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "groupHomeCell") as? GroupHomeCell
    let group = self.groups?.object(at: indexPath.row) as! ChallengeGroup
    
    if (group.name as? String) != nil {
      
    cell?.groupNameLabel.text = group.name as? String
    
    var pointsLabelText = ""
    if self.isMemberOfGroups == true{
      pointsLabelText = "Created by \(group.createdBy!)"
      cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    } else {
       pointsLabelText = group.createdBy! as String
    }
      
    cell?.ptsLabel.text! = pointsLabelText
    cell?.groupImageView.image = UIImage.init(named: (group.imageName)!)
    //print(group.imageName)
    return cell!
      
    } 
    
    return cell!
  }

    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        if FBSDKAccessToken.current() == nil {
             DataService.dataService.CURRENT_USER_REF.unauth()
            // Remove the user's uid from storage
              UserDefaults.standard.setValue(nil, forKey: "uid")
            //print("logged out from regular user account")
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        } else {
            FBSDKAccessToken.current()
            UserDefaults.standard.setValue(nil, forKey: "uid")
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            //print("logged out from Facebook");
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Remove the user's uid from storage
        UserDefaults.standard.setValue(nil, forKey: "uid")
  }
  
  @IBAction func onSearchGroupsPressed(_ sender: AnyObject) {
    let shouldAllowSearch = self.checkDate()
    
    if shouldAllowSearch == true {
      self.performSegue(withIdentifier: "searchGroups", sender: self)
    } else {
    self.cannotSearchGroups()
    }
    
  }
  @IBAction func onCreateNewGroupPressed(_ sender: AnyObject) {
    let shouldAllowNewGroup = self.checkDate()
    
    if shouldAllowNewGroup == true {
      self.performSegue(withIdentifier: "CreateGroup", sender: self)
      self.didAlreadySearchGroups = false
    } else {
      self.cannotSearchGroups()
    }
  }
  
  func checkDate() -> Bool {
    let date1 = Date()
    
    let dateString = "2016-06-07" // change to your date format
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date2 = dateFormatter.date(from: dateString)!
    
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
    let alert = UIAlertController.init(title: "Oops", message: "Challenges can no longer be created or joined", preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "groupDetails" {
      let selectedGroup = self.groups?.object(at: (self.tableView.indexPath(for: sender as! GroupHomeCell)?.row)!) as! ChallengeGroup
     let destVC = segue.destination as! GroupDetailsVC
      destVC.group = selectedGroup
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: false)
  }
    
    @IBAction func unwindToGroupHome(_ segue: UIStoryboardSegue) {
        
    }
  
}
