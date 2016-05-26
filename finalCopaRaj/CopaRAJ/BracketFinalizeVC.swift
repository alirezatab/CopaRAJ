//
//  BracketFinalizeVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class BracketFinalizeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationBarDelegate{
    
    
  @IBOutlet weak var finalizeButton: UIBarButtonItem!
    @IBOutlet weak var BrackeChallangeCollectionView: UICollectionView!
    
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var homeTeamScore: UILabel!
    @IBOutlet weak var homeTeamPenalty: UILabel!

    @IBOutlet weak var visitorTeamImageView: UIImageView!
    @IBOutlet weak var visitorTeamLabel: UILabel!
    @IBOutlet weak var visitorTeamScore: UILabel!
    @IBOutlet weak var visitorTeamPenalty: UILabel!
    
    var group : ChallengeGroup?
  
    var groupsPassedOver : NSMutableArray!
    var playOffMatches: NSMutableArray?
    var miniArray: NSMutableArray?
    
    var matchA1B2: NSMutableArray?
    var matchB1A2: NSMutableArray?
    var matchD1C2: NSMutableArray?
    var matchC1D2: NSMutableArray?
    var matchW25W27: NSMutableArray?
    var matchW26W28: NSMutableArray?
    var matchL29L30: NSMutableArray?
    var matchW29W30: NSMutableArray?
    var tournmentChampion: NSMutableArray?
    
    var teamA1: ChallengeTeam?
    var teamA2: ChallengeTeam?
    var teamB1: ChallengeTeam?
    var teamB2: ChallengeTeam?
    var teamC1: ChallengeTeam?
    var teamC2: ChallengeTeam?
    var teamD1: ChallengeTeam?
    var teamD2: ChallengeTeam?
    var teamW25: ChallengeTeam?
    var teamW26: ChallengeTeam?
    var teamW27: ChallengeTeam?
    var teamW28: ChallengeTeam?
    var teamW29: ChallengeTeam?
    var teamW30: ChallengeTeam?
    var teamChampion: ChallengeTeam?
    
    var teamL29: ChallengeTeam?
    var teamL30: ChallengeTeam?
  
  
    var A1B2Winner : ChallengeTeam?
    var B1A2Winner : ChallengeTeam?
    var C1D2Winner : ChallengeTeam?
    var D1C2Winner : ChallengeTeam?
    var W25W27Winner : ChallengeTeam?
    var W26W28Winner : ChallengeTeam?
    var W29W30Winner : ChallengeTeam?
    var nonWinnner : ChallengeTeam?
    
    
    var cellHeight: CGFloat!
    var cellWidth: CGFloat!
    var minimumInteritemSpacing: CGFloat!
    
    let topInset: CGFloat = 10.0
    let bottomInset: CGFloat = 10.0
    
    let cellsForSection0 = 4
    let cellsForSection1 = 2
    let cellsForSection2 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.hidesBackButton = true
      
       // print(groupsPassedOver)
        let group1 = self.groupsPassedOver.objectAtIndex(0) as! CopaAmericaGroup
        let group2 = self.groupsPassedOver.objectAtIndex(1) as! CopaAmericaGroup
        let group3 = self.groupsPassedOver.objectAtIndex(2) as! CopaAmericaGroup
        let group4 = self.groupsPassedOver.objectAtIndex(3) as! CopaAmericaGroup
        
        //groupA
        self.teamA1 = group1.teams?.objectAtIndex(0) as? ChallengeTeam
        self.teamA2 = group1.teams?.objectAtIndex(1) as? ChallengeTeam
        //groupB
        self.teamB1 = group2.teams?.objectAtIndex(0) as? ChallengeTeam
        self.teamB2 = group2.teams?.objectAtIndex(1) as? ChallengeTeam
        
         self.A1B2Winner = ChallengeTeam(name: "Pick Your Team")
        self.B1A2Winner = ChallengeTeam(name: "Pick Your Team")
        self.C1D2Winner = ChallengeTeam(name: "Pick Your Team")
        self.D1C2Winner = ChallengeTeam(name: "Pick Your Team")
        self.W25W27Winner = ChallengeTeam(name: "Pick Your Team")
        self.W26W28Winner = ChallengeTeam(name: "Pick Your Team")
        self.W29W30Winner = ChallengeTeam(name: "Pick Your Team")
        



        //groupC
        self.teamC1 = group3.teams?.objectAtIndex(0) as? ChallengeTeam
        self.teamC2 = group3.teams?.objectAtIndex(1) as? ChallengeTeam
        //groupD
        self.teamD1 = group4.teams?.objectAtIndex(0) as? ChallengeTeam
        self.teamD2 = group4.teams?.objectAtIndex(1) as? ChallengeTeam
        
        self.teamW25 = ChallengeTeam(name: "Pick Your Team")
        self.teamW26 = ChallengeTeam(name: "Pick Your Team")
        self.teamW27 = ChallengeTeam(name: "Pick Your Team")
        self.teamW28 = ChallengeTeam(name: "Pick Your Team")
        self.teamW29 = ChallengeTeam(name: "Pick Your Team")
        self.teamW30 = ChallengeTeam(name: "Pick Your Team")
        self.teamChampion = ChallengeTeam(name: "Pick Your Champion")
        
        
        
        //quarterFinal Matches
        self.matchA1B2 = [self.teamA1!, self.teamB2!, A1B2Winner!]
        self.matchD1C2 = [self.teamD1!, self.teamC2!, D1C2Winner!]
        self.matchB1A2 = [self.teamB1!, self.teamA2!, B1A2Winner!]
        self.matchC1D2 = [self.teamC1!, self.teamD2!, C1D2Winner!]
      
        self.matchW25W27 = [A1B2Winner!, D1C2Winner!, W25W27Winner!]
        self.matchW26W28 = [B1A2Winner!, C1D2Winner!, W26W28Winner!]
        //self.matchL29L30 = [self.teamL29!, self.teamL30!]
        self.matchW29W30 = [W25W27Winner!, W26W28Winner!, W29W30Winner!]
        self.tournmentChampion = [W29W30Winner!, W29W30Winner!, W29W30Winner!]
        
        self.playOffMatches = NSMutableArray()
      
      //double check
        self.playOffMatches?.addObjectsFromArray([self.matchA1B2!, self.matchD1C2!, self.matchB1A2!,  self.matchC1D2!, self.matchW25W27!, self.matchW26W28!, self.matchW29W30!, self.tournmentChampion!])
        
        self.finalizeButton.enabled = false
    }
    
    func resetNonWinner() {
        self.nonWinnner = ChallengeTeam(name: "Pick Your Team")
    }
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.BrackeChallangeCollectionView.dequeueReusableCellWithReuseIdentifier("ChallangeCell", forIndexPath: indexPath) as! BracketCell
        let cellFinal = self.BrackeChallangeCollectionView.dequeueReusableCellWithReuseIdentifier("ChallangeFinalCell", forIndexPath: indexPath) as! BracketCell
        
        cell.layer.cornerRadius = 10.0
        cell.contentView.layer.masksToBounds = true
        
        cellFinal.layer.cornerRadius = 10.0
        cell.contentView.layer.masksToBounds = true
        
        switch indexPath.section {
        case 0:
            self.miniArray = NSMutableArray()
            self.miniArray = (self.playOffMatches?.objectAtIndex(indexPath.row) as! NSMutableArray)
            
            let homeTeam = self.miniArray?.objectAtIndex(0) as! ChallengeTeam
            cell.homeTeamImageView.image = UIImage.init(named: homeTeam.name as! String)
            cell.homeTeamLabel.text = homeTeam.name as? String
            
            let visitorTeam = self.miniArray?.objectAtIndex(1) as! ChallengeTeam
            cell.visitorTeamImageView.image = UIImage(named: visitorTeam.name as! String)
            cell.visitorTeamLabel.text = visitorTeam.name as? String
            
            return cell
        case 1:
            self.miniArray = NSMutableArray()
            self.miniArray = (self.playOffMatches?.objectAtIndex(indexPath.row+4) as! NSMutableArray)
            
            let homeTeam = self.miniArray?.objectAtIndex(0) as! ChallengeTeam
            cell.homeTeamImageView.image = UIImage.init(named: homeTeam.name as! String)
            cell.homeTeamLabel.text = homeTeam.name as? String
            
            let visitorTeam = self.miniArray?.objectAtIndex(1) as! ChallengeTeam
            cell.visitorTeamImageView.image = UIImage(named: visitorTeam.name as! String)
            cell.visitorTeamLabel.text = visitorTeam.name as? String
            
            return cell
        case 2:
            self.miniArray = NSMutableArray()
            self.miniArray = (self.playOffMatches?.objectAtIndex(indexPath.row+6) as! NSMutableArray)
            
            let homeTeam = self.miniArray?.objectAtIndex(0) as! ChallengeTeam
            cell.homeTeamImageView.image = UIImage(named: homeTeam.name as! String)
            cell.homeTeamLabel.text = homeTeam.name as? String
            
            let visitorTeam = self.miniArray?.objectAtIndex(1) as! ChallengeTeam
            cell.visitorTeamImageView.image = UIImage(named: visitorTeam.name as! String)
            cell.visitorTeamLabel.text = visitorTeam.name as? String
            return cell
        case 3:
            self.miniArray = NSMutableArray()
            self.miniArray = (self.playOffMatches?.objectAtIndex(indexPath.row+7) as! NSMutableArray)
            
            let teamChampion = self.miniArray?.objectAtIndex(0) as! ChallengeTeam
            
            cellFinal.winnerTeamImageView.image = UIImage(named: teamChampion.name as! String)
            cellFinal.winnerTeamLabel.text = teamChampion.name as? String
            
            return cellFinal
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return (self.groupsPassedOver?.count)!
        } else if section == 1 {
            return (self.groupsPassedOver?.count)!/2
        } else {
            return ((self.groupsPassedOver?.count)!/(self.groupsPassedOver?.count)!)
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (self.groupsPassedOver?.count)!
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.cellHeight = (self.BrackeChallangeCollectionView.bounds.size.height-self.topInset-self.bottomInset-60)/4;
        self.cellWidth = self.BrackeChallangeCollectionView.bounds.size.width/1.5;
        return CGSizeMake(self.cellWidth, self.cellHeight);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(self.topInset, 30, self.bottomInset, 0)
        } else if section == 1 {
            return UIEdgeInsetsMake((self.topInset+(self.cellHeight/2)+self.minimumInteritemSpacing), 50, self.bottomInset + self.cellHeight/2 + self.minimumInteritemSpacing, 0)
        } else {
            return UIEdgeInsetsMake(self.view.frame.size.height/3, 50, 50, 50)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if section == 0 {
            self.minimumInteritemSpacing = 10
            return self.minimumInteritemSpacing
        } else if section == 1 {
            self.minimumInteritemSpacing = self.cellHeight-50
            return self.minimumInteritemSpacing
        } else {
            self.minimumInteritemSpacing = 10;
            return self.minimumInteritemSpacing
        }
    }
    
    @IBAction func onPickPossiblePlayoffHomeTeamsButtonPressed(sender: UIButton) {
        
        let buttonPoint = sender.convertPoint(CGPointZero, toView: BrackeChallangeCollectionView)
        //print(buttonPoint)
        let indexPath = BrackeChallangeCollectionView.indexPathForItemAtPoint(buttonPoint)
        
        if indexPath?.section == 0 {
            self.miniArray = NSMutableArray()
            self.miniArray = (self.playOffMatches?.objectAtIndex((indexPath?.row)!) as! NSMutableArray)
            
            let selectedTeam = self.miniArray?.objectAtIndex(0) as! ChallengeTeam
           // print(selectedTeam.name)
            if indexPath?.row == 0 {
                self.A1B2Winner?.name = selectedTeam.name
            } else if indexPath?.row == 1 {
                self.D1C2Winner?.name = selectedTeam.name
            } else if indexPath?.row == 2 {
                self.B1A2Winner?.name = selectedTeam.name
            } else if indexPath?.row == 3 {
                self.C1D2Winner?.name = selectedTeam.name
            }
        } else if indexPath?.section == 1 {
            self.miniArray = NSMutableArray()
            self.miniArray = (self.playOffMatches?.objectAtIndex((indexPath?.row)!+4) as! NSMutableArray)
            
            let selectedTeam = self.miniArray?.objectAtIndex(0) as! ChallengeTeam
            if indexPath?.row == 0 {
                self.W25W27Winner?.name = selectedTeam.name
            } else if indexPath?.row == 1 {
                self.W26W28Winner?.name = selectedTeam.name
            }
        } else {
            self.miniArray = NSMutableArray()
            self.miniArray = (self.playOffMatches?.objectAtIndex((indexPath?.row)!+6) as! NSMutableArray)
            
            let selectedTeam = self.miniArray?.objectAtIndex(0) as! ChallengeTeam
            //print(selectedTeam.name)
            self.W29W30Winner?.name = selectedTeam.name
        }
        self.checkWinners()
        self.BrackeChallangeCollectionView.reloadData()
    }
  
  
  func checkWinners() {
    for match in self.playOffMatches! {
      self.checkMatchArrayForWinnerMatch(match as! NSMutableArray)
    }
    let finalizeEnabled = self.checkFinalize()
    if finalizeEnabled {
      self.finalizeButton.enabled = true
        self.finalizeButton.tintColor = UIColor.whiteColor()
    } else {
      self.finalizeButton.enabled = false
        self.finalizeButton.tintColor = UIColor.lightGrayColor()
      
    }
  }
  
  func checkMatchArrayForWinnerMatch(match: NSMutableArray) {
    let winner = match.objectAtIndex(2) as! ChallengeTeam
    let local = match.objectAtIndex(0) as! ChallengeTeam
    let visitor = match.objectAtIndex(1) as! ChallengeTeam
    if winner.name != local.name && winner.name != visitor.name{
      self.resetNonWinner()
      winner.name = self.nonWinnner?.name
    }
  }
    
    @IBAction func onPickPossiblePlayoffVisitorTeamsButtonPressed(sender: UIButton) {
      let buttonPoint = sender.convertPoint(CGPointZero, toView: BrackeChallangeCollectionView)
      //print(buttonPoint)
      let indexPath = BrackeChallangeCollectionView.indexPathForItemAtPoint(buttonPoint)
      
      if indexPath?.section == 0 {
        self.miniArray = NSMutableArray()
        self.miniArray = (self.playOffMatches?.objectAtIndex((indexPath?.row)!) as! NSMutableArray)
        
        let selectedTeam = self.miniArray?.objectAtIndex(1) as! ChallengeTeam
        //print(selectedTeam.name)
        if indexPath?.row == 0 {
          self.A1B2Winner?.name = selectedTeam.name
        } else if indexPath?.row == 1 {
          self.D1C2Winner?.name = selectedTeam.name
        } else if indexPath?.row == 2 {
          self.B1A2Winner?.name = selectedTeam.name
        } else if indexPath?.row == 3 {
          self.C1D2Winner?.name = selectedTeam.name
        }
      } else if indexPath?.section == 1 {
        self.miniArray = NSMutableArray()
        self.miniArray = (self.playOffMatches?.objectAtIndex((indexPath?.row)!+4) as! NSMutableArray)
        
        let selectedTeam = self.miniArray?.objectAtIndex(1) as! ChallengeTeam
        if indexPath?.row == 0 {
          self.W25W27Winner?.name = selectedTeam.name
        } else if indexPath?.row == 1 {
          self.W26W28Winner?.name = selectedTeam.name
        }
      } else {
        self.miniArray = NSMutableArray()
        self.miniArray = (self.playOffMatches?.objectAtIndex((indexPath?.row)!+6) as! NSMutableArray)
        
        let selectedTeam = self.miniArray?.objectAtIndex(1) as! ChallengeTeam
        //print(selectedTeam.name)
        self.W29W30Winner?.name = selectedTeam.name
      }
      
      self.checkWinners()
      self.BrackeChallangeCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  func checkFinalize() -> Bool {
    var enableButton = true
    
    if self.teamChampion?.name == "Pick Your Team" {
      enableButton = false
      return enableButton
    } else if self.W29W30Winner!.name == "Pick Your Team" || self.W26W28Winner!.name == "Pick Your Team" || W25W27Winner!.name == "Pick Your Team" {
      enableButton = false
      return enableButton
    } else if self.A1B2Winner!.name == "Pick Your Team" || self.B1A2Winner!.name == "Pick Your Team" || self.C1D2Winner?.name == "Pick Your Team" || self.D1C2Winner == "Pick Your Team" {
      enableButton = false
      return enableButton
    }
    
    
    return enableButton
  }
  
    @IBAction func onFinalizeButtonPressed(sender: UIBarButtonItem) {
        let finalPicks = self.createFinalPicks()
        self.updateUserPicksToGroup(finalPicks, group: self.group!)
    }
  
  func createFinalPicks() -> NSDictionary {
    
    let firstName = NSUserDefaults.standardUserDefaults().valueForKey("firstName") as? String
    let lastName = NSUserDefaults.standardUserDefaults().valueForKey("lastName") as? String
    let groupA = self.groupsPassedOver.objectAtIndex(0) as! CopaAmericaGroup
    let GroupAWinner = groupA.teams?.objectAtIndex(0) as! ChallengeTeam
    let GroupARunnerUP = groupA.teams?.objectAtIndex(1) as! ChallengeTeam
    let GroupAThirdPlace = groupA.teams?.objectAtIndex(2) as! ChallengeTeam
    let GroupAFourthPlace = groupA.teams?.objectAtIndex(3) as! ChallengeTeam
    
    let groupB = self.groupsPassedOver.objectAtIndex(1) as! CopaAmericaGroup
    let GroupBWinner = groupB.teams?.objectAtIndex(0) as! ChallengeTeam
    let GroupBRunnerUP = groupB.teams?.objectAtIndex(1) as! ChallengeTeam
    let GroupBThirdPlace = groupB.teams?.objectAtIndex(2) as! ChallengeTeam
    let GroupBFourthPlace = groupB.teams?.objectAtIndex(3) as! ChallengeTeam
    
    let groupC = self.groupsPassedOver.objectAtIndex(2) as! CopaAmericaGroup
    let GroupCWinner = groupC.teams?.objectAtIndex(0) as! ChallengeTeam
    let GroupCRunnerUP = groupC.teams?.objectAtIndex(1) as! ChallengeTeam
    let GroupCThirdPlace = groupC.teams?.objectAtIndex(2) as! ChallengeTeam
    let GroupCFourthPlace = groupC.teams?.objectAtIndex(3) as! ChallengeTeam
    
    let groupD = self.groupsPassedOver.objectAtIndex(3) as! CopaAmericaGroup
    let GroupDWinner = groupD.teams?.objectAtIndex(0) as! ChallengeTeam
    let GroupDRunnerUP = groupD.teams?.objectAtIndex(1) as! ChallengeTeam
    let GroupDThirdPlace = groupD.teams?.objectAtIndex(2) as! ChallengeTeam
    let GroupDFourthPlace = groupD.teams?.objectAtIndex(3) as! ChallengeTeam
    
    let userPickDetails = ["GroupAWinner": GroupAWinner.name as! String,
                           "GroupARunnerUP": GroupARunnerUP.name as! String,
                           "GroupAThirdPlace": GroupAThirdPlace.name as! String,
                           "GroupAFourthPlace": GroupAFourthPlace.name as! String,
                           "GroupBWinner": GroupBWinner.name as! String,
                           "GroupBRunnerUP": GroupBRunnerUP.name as! String,
                           "GroupBThirdPlace": GroupBThirdPlace.name as! String,
                           "GroupBFourthPlace": GroupBFourthPlace.name as! String,
                           "GroupCWinner": GroupCWinner.name as! String,
                           "GroupCRunnerUP": GroupCRunnerUP.name as! String,
                           "GroupCThirdPlace": GroupCThirdPlace.name as! String,
                           "GroupCFourthPlace": GroupCFourthPlace.name as! String,
                           "GroupDWinner": GroupDWinner.name as! String,
                           "GroupDRunnerUP": GroupDRunnerUP.name as! String,
                           "GroupDThirdPlace": GroupDThirdPlace.name as! String,
                           "GroupDFourthPlace": GroupDFourthPlace.name as! String,
                           "SemifinalistTeam1":self.A1B2Winner?.name as! String,
                           "SemifinalistTeam2":self.D1C2Winner?.name as! String,
                           "SemifinalistTeam3":self.B1A2Winner?.name as! String,
                           "SemifinalistTeam4":self.C1D2Winner?.name as! String,
                           "FinalistTeam1": self.W25W27Winner?.name as! String,
                           "FinalistTeam2":self.W26W28Winner?.name as! String,
                           "Champion": self.W29W30Winner?.name as! String,
                           "firstName":firstName! as String,
                           "lastName": lastName! as String]
    
    return userPickDetails
  }
  
  func updateUserPicksToGroup(picks : NSDictionary,group: ChallengeGroup) {
    //print(self.group?.groupID as! String)
    let uid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    let ref = DataService.dataService.CHALLENGEGROUPS_REF.childByAppendingPath(self.group!.groupID as! String).childByAppendingPath(uid)
    ref.setValue(picks) { (error, ref) in
      if let wasAnError = error {
        print(wasAnError.localizedDescription)
      } else {
        self.presentPicksAddedToGroup(group)
      }
    }
  }
  
  func presentPicksAddedToGroup (group : ChallengeGroup) {
    let alert = UIAlertController(title: "Success", message: "Your picks have been added to \(group.name!). You can now see other member's picks!", preferredStyle: .Alert)
    let ok = UIAlertAction(title: "OK", style: .Cancel) { (action) in
      let count = self.navigationController?.viewControllers.count
      let groupDetails = self.navigationController?.viewControllers[(count!-3)]
      self.navigationController?.popToViewController(groupDetails!, animated: false)
    }
    alert.addAction(ok)
    self.presentViewController(alert, animated: true) {
    }
  
  }

}
