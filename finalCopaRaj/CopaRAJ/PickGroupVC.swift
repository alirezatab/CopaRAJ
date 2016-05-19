//
//  PickGroupVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class PickGroupVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var groups : NSMutableArray?
  
  override func viewDidLoad() {
    self.navigationController?.navigationBarHidden = false
    self.title = "Make Group Selections"
    self.createGroups()
    self.tableView.userInteractionEnabled = true
    self.tableView.allowsSelection = true
    self.tableView.setEditing(true, animated: true)
    
    
    
  }
  
  func createGroups() {
    self.groups = NSMutableArray()
    let groupA = CopaAmericaGroup(name: "Group A")
    let groupB = CopaAmericaGroup(name: "Group B")
    let groupC = CopaAmericaGroup(name: "Group C")
    let groupD = CopaAmericaGroup(name: "Group D")
    
    let groupATeams = NSMutableArray()
    let groupBTeams = NSMutableArray()
    let groupCTeams = NSMutableArray()
    let groupDTeams = NSMutableArray()
   for i in 1...4  {
    if i == 1 {
      let Team1 = ChallengeTeam (name: "Colombia")
      let Team2 = ChallengeTeam (name: "United States")
      let Team3 = ChallengeTeam (name: "Costa Rica")
      let Team4 = ChallengeTeam (name: "Paraguay")
      groupATeams.addObjectsFromArray([Team1,Team2,Team3,Team4])
      groupA.teams = groupATeams
    } else if i == 2 {
      let Team1 = ChallengeTeam (name: "Brazil")
      let Team2 = ChallengeTeam (name: "Ecuador")
      let Team3 = ChallengeTeam (name: "Haiti")
      let Team4 = ChallengeTeam (name: "Peru")
      groupBTeams.addObjectsFromArray([Team1,Team2,Team3,Team4])
      groupB.teams = groupBTeams

    } else if i == 3 {
      let Team1 = ChallengeTeam (name: "Jamaica")
      let Team2 = ChallengeTeam (name: "Mexico")
      let Team3 = ChallengeTeam (name: "Uruguay")
      let Team4 = ChallengeTeam (name: "Venezuela")
      groupCTeams.addObjectsFromArray([Team1,Team2,Team3,Team4])
      groupC.teams = groupCTeams

    } else {
      let Team1 = ChallengeTeam (name: "Argentina")
      let Team2 = ChallengeTeam (name: "Bolivia")
      let Team3 = ChallengeTeam (name: "Chile")
      let Team4 = ChallengeTeam (name: "Panama")
      groupDTeams.addObjectsFromArray([Team1,Team2,Team3,Team4])
      groupD.teams = groupDTeams

    }
    }
    self.groups?.addObjectsFromArray([groupA, groupB, groupC, groupD])
    self.tableView.reloadData()
    self.tableView.editing = true
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("team") as! GroupTableViewCell
    let cellGroup = self.groups?.objectAtIndex(indexPath.section) as! CopaAmericaGroup
    let team = cellGroup.teams?.objectAtIndex(indexPath.row) as! ChallengeTeam
    cell.teamImage.image = UIImage.init(named: team.name as! String)
    cell.teamCountry.text = team.name as? String
    
    if team.name == "United States" {
      cell.teamCountry.text = NSLocalizedString("United States", comment:"")
    }
    
    
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return (self.groups?.count)!
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let screenBound = UIScreen.mainScreen().bounds
    let screensize = screenBound.size
    let screenwidth = screensize.width
    
    let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
    
    let groupLabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.size.width / 4, 45))
    
    CGRectMake(20, 5, screenwidth/2, 45)
    groupLabel.font = UIFont.init(name: "GothamMedium", size: 15)
    groupLabel.textColor = UIColor.init(white: 0.600, alpha: 1.000)
    groupLabel.textAlignment = NSTextAlignment.Center
   
    headerView.backgroundColor = UIColor.init(white: 0.969, alpha: 1.000)//your background
    
    let group = self.groups!.objectAtIndex(section) as! CopaAmericaGroup
    groupLabel.text = group.name as? String
    
    headerView.addSubview(groupLabel)
    
    return headerView;
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
   func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
  
   func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return .None
  }
  
  func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    let group = self.groups?.objectAtIndex(sourceIndexPath.section) as! CopaAmericaGroup
    let team = group.teams?.objectAtIndex(sourceIndexPath.row)
    group.teams?.removeObjectAtIndex(sourceIndexPath.row)
    group.teams?.insertObject(team!, atIndex: destinationIndexPath.row)
    
  }
  
  
  
  func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
    if sourceIndexPath.section != proposedDestinationIndexPath.section {
      var row = 0 as NSInteger
      if sourceIndexPath.section < proposedDestinationIndexPath.section {
        row = tableView.numberOfRowsInSection(sourceIndexPath.section) - 1
      }
      return NSIndexPath.init(forRow: row, inSection: sourceIndexPath.section)
    }
    return proposedDestinationIndexPath
  }

  @IBAction func finalizeButtonPressed(sender: UIButton) {
    let cellGroups = self.groups
    for group in cellGroups! {
      let groupCopa = group as! CopaAmericaGroup
      for team in groupCopa.teams! {
        print(team.name as String)
      }
    }

  }

}
