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
    @IBOutlet weak var finalizeGroupStandingButton: UIButton!
  
  var groups : NSMutableArray?
  var group : ChallengeGroup?
    //var token : dispatch_once_t = 0
    
  override func viewDidLoad() {
    self.navigationController?.isNavigationBarHidden = false
    self.navigationItem.hidesBackButton = true
    self.title = "Group Selections"
    self.createGroups()
    self.tableView.isUserInteractionEnabled = true
    self.tableView.allowsSelection = true
    self.tableView.setEditing(true, animated: true)
    
    //dispatch_once(&token){
    self.howToReorderAlert("How To Make Your Picks", message: "Drag and drop teams within each group using \u{2261}. Then click finalize when you are done.")
    //}
    
    //self.finalizeGroupStandingButton.layer.cornerRadius = 5
    //self.finalizeGroupStandingButton.layer.masksToBounds = true
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
      groupATeams.addObjects(from: [Team1,Team2,Team3,Team4])
      groupA.teams = groupATeams
    } else if i == 2 {
      let Team1 = ChallengeTeam (name: "Brazil")
      let Team2 = ChallengeTeam (name: "Ecuador")
      let Team3 = ChallengeTeam (name: "Haiti")
      let Team4 = ChallengeTeam (name: "Peru")
      groupBTeams.addObjects(from: [Team1,Team2,Team3,Team4])
      groupB.teams = groupBTeams

    } else if i == 3 {
      let Team1 = ChallengeTeam (name: "Jamaica")
      let Team2 = ChallengeTeam (name: "Mexico")
      let Team3 = ChallengeTeam (name: "Uruguay")
      let Team4 = ChallengeTeam (name: "Venezuela")
      groupCTeams.addObjects(from: [Team1,Team2,Team3,Team4])
      groupC.teams = groupCTeams

    } else {
      let Team1 = ChallengeTeam (name: "Argentina")
      let Team2 = ChallengeTeam (name: "Bolivia")
      let Team3 = ChallengeTeam (name: "Chile")
      let Team4 = ChallengeTeam (name: "Panama")
      groupDTeams.addObjects(from: [Team1,Team2,Team3,Team4])
      groupD.teams = groupDTeams

    }
    }
    self.groups?.addObjects(from: [groupA, groupB, groupC, groupD])
    self.tableView.reloadData()
    self.tableView.isEditing = true
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "team") as! GroupTableViewCell
    let cellGroup = self.groups?.object(at: indexPath.section) as! CopaAmericaGroup
    let team = cellGroup.teams?.object(at: indexPath.row) as! ChallengeTeam
    cell.teamImage.image = UIImage.init(named: team.name as! String)
    cell.teamCountry.text = team.name as? String
    
    if team.name == "United States" {
      cell.teamCountry.text = NSLocalizedString("United States", comment:"")
    }    
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return (self.groups?.count)!
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let screenBound = UIScreen.main.bounds
    let screensize = screenBound.size
    let screenwidth = screensize.width
    
    let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
    
    let groupLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 4, height: 40))
    let instructionLabel = UILabel.init(frame: CGRect(x: self.view.frame.size.width/2, y: 0, width: self.view.frame.size.width/2, height: 40))
    
    CGRect(x: 20, y: 5, width: screenwidth/2, height: 45)
    groupLabel.font = UIFont.init(name: "GothamMedium", size: 17)
    groupLabel.textColor = UIColor.init(white: 0.600, alpha: 1.000)
    groupLabel.textAlignment = NSTextAlignment.center
   
    instructionLabel.font = UIFont.init(name: "GothamMedium", size: 15)
    instructionLabel.textColor = UIColor.init(white: 0.600, alpha: 1.000)
    instructionLabel.textAlignment = NSTextAlignment.right
    
    headerView.backgroundColor = UIColor.init(white: 0.969, alpha: 1.000)//your background
    
    let group = self.groups!.object(at: section) as! CopaAmericaGroup
    groupLabel.text = group.name as? String
    instructionLabel.text = "Sort using \u{2261}"
    
    headerView.addSubview(groupLabel)
    headerView.addSubview(instructionLabel)
    
    return headerView;
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
   func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
   func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .none
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let group = self.groups?.object(at: sourceIndexPath.section) as! CopaAmericaGroup
    let team = group.teams?.object(at: sourceIndexPath.row)
    group.teams?.removeObject(at: sourceIndexPath.row)
    group.teams?.insert(team!, at: destinationIndexPath.row)
    
  }
  
  
  
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
    if sourceIndexPath.section != proposedDestinationIndexPath.section {
      var row = 0 as NSInteger
      if sourceIndexPath.section < proposedDestinationIndexPath.section {
        row = tableView.numberOfRows(inSection: sourceIndexPath.section) - 1
      }
      return IndexPath.init(row: row, section: sourceIndexPath.section)
    }
    return proposedDestinationIndexPath
    }

    @IBAction func finalizeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "BracketFinalize", sender: nil)
    }
    
    //MARK: ALERT
    //Ali added
    func howToReorderAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Got It", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
  @IBAction func unwindToPickGroup(_ segue: UIStoryboardSegue) {
    
  }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? BracketFinalizeVC {
            desVC.groupsPassedOver = self.groups
            desVC.group = self.group
        }
    }
}
