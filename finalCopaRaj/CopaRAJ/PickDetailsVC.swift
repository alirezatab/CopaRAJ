//
//  PickDetailsVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

class PickDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var member :ChallengeUser?
  var picksArray : NSMutableArray?
  
  override func viewDidLoad() {
    self.title = "\(self.member!.firstName!) \(self.member!.lastName!)'s Selections"
    self.createGroups()
    self.navigationController?.navigationBarHidden = false
    self.tableView.userInteractionEnabled = true
    self.tableView.reloadData()
    
  }
  
  
  func createGroups() {
    picksArray = NSMutableArray()
    let groupA = CopaAmericaGroup(name: "Group A")
    let groupATeams = NSMutableArray()
    self.updtateArray(groupATeams, team1: (self.member?.GroupAWinner)!, team2: (self.member?.GroupBWinner)!, team3: (self.member?.GroupAThirdPlace)!, team4: (self.member?.GroupAFourthPlace)!)
    groupA.teams = groupATeams
    
    let groupB = CopaAmericaGroup(name: "Group B")
    let groupBTeams = NSMutableArray()
    self.updtateArray(groupBTeams, team1: self.member!.GroupBWinner!, team2: self.member!.GroupBRunnerUP!, team3: self.member!.GroupBThirdPlace!, team4: self.member!.GroupBFourthPlace!)
    groupB.teams = groupBTeams
    
    let groupC = CopaAmericaGroup(name: "Group C")
    let groupCTeams = NSMutableArray()
    self.updtateArray(groupCTeams, team1: self.member!.GroupCWinner!, team2: self.member!.GroupCRunnerUP!, team3: self.member!.GroupCThirdPlace!, team4: self.member!.GroupCFourthPlace!)
    groupC.teams = groupCTeams
    
    let groupD = CopaAmericaGroup(name: "Group D")
    let groupDTeams = NSMutableArray()
    self.updtateArray(groupDTeams, team1: self.member!.GroupDWinner!, team2: self.member!.GroupDRunnerUP!, team3: self.member!.GroupDThirdPlace!, team4: self.member!.GroupDFourthPlace!)
    groupD.teams = groupDTeams
    
    let quarterfinalists = CopaAmericaGroup(name: "Quarterfinalists")
    quarterfinalists.teams = [self.member!.GroupAWinner!, self.member!.GroupARunnerUP!, self.member!.GroupBWinner!, self.member!.GroupBRunnerUP!, self.member!.GroupCWinner!, self.member!.GroupCRunnerUP!, self.member!.GroupDWinner!, self.member!.GroupDRunnerUP!]
    
    let semifinalists = CopaAmericaGroup(name: "SemiFinalists")
    semifinalists.teams = [self.member!.SemifinalistTeam1!, self.member!.SemifinalistTeam2!, self.member!.SemifinalistTeam3!, self.member!.SemifinalistTeam4!]
    
    let finalists = CopaAmericaGroup(name: "Finalists")
    finalists.teams = [self.member!.FinalistTeam1!, self.member!.FinalistTeam2!]
    
    let champion = CopaAmericaGroup(name: "Champion")
    champion.teams = [self.member!.Champion!]
    
    self.picksArray?.addObjectsFromArray([groupA, groupB, groupC, groupD, quarterfinalists, semifinalists, finalists, champion])
    
}

  func updtateArray(groupArray: NSMutableArray, team1: String, team2: String, team3: String, team4: String ) {
    let winner = self.member?.GroupAWinner
    let runnerUp = self.member?.GroupARunnerUP
    let thirdPlace = self.member?.GroupAThirdPlace
    let fourthPlace = self.member?.GroupAFourthPlace
    groupArray.addObjectsFromArray([winner!, runnerUp!, thirdPlace!, fourthPlace!])
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let group = self.picksArray?.objectAtIndex(section) as! CopaAmericaGroup
    let numberOfRows = group.teams?.count
    
    return numberOfRows!
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("team") as! GroupTableViewCell
    let cellGroup = self.picksArray?.objectAtIndex(indexPath.section) as! CopaAmericaGroup
    let teamName = cellGroup.teams?.objectAtIndex(indexPath.row) as! String
    cell.teamImage.image = UIImage.init(named: teamName)
    let place = indexPath.row + 1
    cell.teamCountry.text = "\(place). \(teamName)"
    
    if teamName == "United States" {
      cell.teamCountry.text = NSLocalizedString("United States", comment:"")
    }
    
    
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if let count = self.picksArray?.count {
      return count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let screenBound = UIScreen.mainScreen().bounds
    let screensize = screenBound.size
    let screenwidth = screensize.width
    
    let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
    
    let groupLabel = UILabel.init(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 45))
    
    CGRectMake(20, 5, screenwidth/2, 45)
    groupLabel.font = UIFont.init(name: "GothamMedium", size: 15)
    groupLabel.textColor = UIColor.init(white: 0.600, alpha: 1.000)
    groupLabel.textAlignment = NSTextAlignment.Center
    
    headerView.backgroundColor = UIColor.init(white: 0.969, alpha: 1.000)//your background
    
    let group = self.picksArray!.objectAtIndex(section) as! CopaAmericaGroup
    if section != 7 {
    groupLabel.text = "\(group.name as! String) picks"
    } else {
      groupLabel.text = "Champion"
    }
    
    headerView.addSubview(groupLabel)
    
    return headerView;
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  

}
