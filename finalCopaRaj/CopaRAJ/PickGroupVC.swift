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
    self.createGroups()
    
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
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    return cell
  }

}
