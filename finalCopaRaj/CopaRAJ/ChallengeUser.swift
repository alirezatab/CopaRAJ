//
//  ChallengeUser.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/16/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

class ChallengeUser: NSObject {
  
  static let challengeUser = ChallengeUser()
  
  var firstName : String?
  var lastName : String?

  var points : NSNumber
  var picks : [String: String]
  var GroupAWinner : String?
  var GroupARunnerUP : String?
  var GroupAThirdPlace : String?
  var GroupAFourthPlace : String?
  var GroupBWinner : String?
  var GroupBRunnerUP : String?
  var GroupBThirdPlace : String?
  var GroupBFourthPlace : String?
  var GroupCWinner : String?
  var GroupCRunnerUP : String?
  var GroupCThirdPlace : String?
  var GroupCFourthPlace : String?
  var GroupDWinner : String?
  var GroupDRunnerUP : String?
  var GroupDThirdPlace : String?
  var GroupDFourthPlace : String?
  var SemifinalistTeam1 : String?
  var SemifinalistTeam2 : String?
  var SemifinalistTeam3 : String?
  var SemifinalistTeam4 : String?
  var FinalistTeam1 : String?
  var FinalistTeam2 : String?
  var Champion : String?
  
  

  
  override init() {
    self.picks = ["GroupAWinner": "",
                  "GroupARunnerUP": "",
                  "GroupAThirdPlace": "",
                  "GroupAFourthPlace": "",
                  "GroupBWinner": "",
                  "GroupBRunnerUP": "",
                  "GroupBThirdPlace": "",
                  "GroupBFourthPlace": "",
                  "GroupCWinner": "",
                  "GroupCRunnerUP": "",
                  "GroupCThirdPlace": "",
                  "GroupCFourthPlace": "",
                  "GroupDWinner": "",
                  "GroupDRunnerUP": "",
                  "GroupDThirdPlace": "",
                  "GroupDFourthPlace": "",
                  "SemifinalistTeam1":"",
                  "SemifinalistTeam2":"",
                  "SemifinalistTeam3":"",
                  "SemifinalistTeam4":"",
                  "FinalistTeam1": "",
                  "FinalistTeam2":"",
                  "Champion": ""]
    self.points = 0
  }
  
  var defaultPics: [String: String] {
    let userPickDetails = ["GroupAWinner": "", "GroupARunnerUP": "", "GroupAThirdPlace": "", "GroupAFourthPlace": "", "GroupBWinner": "", "GroupBRunnerUP": "", "GroupBThirdPlace": "", "GroupBFourthPlace": "", "GroupCWinner": "", "GroupCRunnerUP": "", "GroupCThirdPlace": "", "GroupCFourthPlace": "", "GroupDWinner": "", "GroupDRunnerUP": "", "GroupDThirdPlace": "", "GroupDFourthPlace": "", "SemifinalistTeam1":"", "SemifinalistTeam2":"", "SemifinalistTeam3":"", "SemifinalistTeam4":"", "FinalistTeam1": "", "FinalistTeam2":"", "Champion": ""]
    
    return userPickDetails
  }
  
  var selectionsArray: NSArray {
    let returnedArray = NSArray(objects: self.GroupAWinner!, self.GroupARunnerUP!, self.GroupAThirdPlace!, self.GroupAFourthPlace!, self.GroupBWinner!, self.GroupBRunnerUP!, self.GroupBThirdPlace!, self.GroupBFourthPlace!, self.GroupCWinner!, self.GroupCRunnerUP!, self.GroupCThirdPlace!, self.GroupCFourthPlace!, self.GroupDWinner!, self.GroupDRunnerUP!, self.GroupDThirdPlace!, self.GroupDFourthPlace!, self.SemifinalistTeam1!, self.SemifinalistTeam2!, self.SemifinalistTeam3!, self.SemifinalistTeam4!, self.FinalistTeam1!, self.FinalistTeam2!, self.Champion!)
 
    return returnedArray
  }
  
  func updatePointsWithResults (results : NSDictionary) {
    var pointsScored = 0
    let pointsPerRound = 64
    let teamsInFirstRound  = 16
    let firstRoundCorrectPick = pointsPerRound / teamsInFirstRound
    
    let teamsInQuarterfinals = 8
    let quarterFinalsCorrectPick = pointsPerRound / teamsInQuarterfinals
    
    let teamsInSemifinlas = 4
    let semiFinalsCorrectPick = pointsPerRound / teamsInSemifinlas

    let teamsInFinals = 2
    let finalsCorrectPick = pointsPerRound / teamsInFinals
    
    let championTeams = 1
    let championCorrectPick = pointsPerRound / championTeams
    
    let groupAWinnerActual = results.valueForKey("GroupAWinner") as! String
    let groupARunnerUPActual = results.valueForKey("GroupARunnerUP") as! String

    if groupAWinnerActual != "GroupAWinner"{
      if groupAWinnerActual == self.GroupAWinner! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupARunnerUPActual  == self.GroupARunnerUP! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupAThirdPlace = results.valueForKey("GroupAThirdPlace") as! String
      if groupAThirdPlace == self.GroupAThirdPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupAFourthPlace = results.valueForKey("GroupAFourthPlace") as! String
      if groupAFourthPlace == self.GroupAFourthPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
    }
    
    
    let groupBWinnerActual = results.valueForKey("GroupBWinner") as! String
    let groupBRunnerUPActual = results.valueForKey("GroupBRunnerUP") as! String

    if groupBWinnerActual != "GroupBWinner" {
      if groupBWinnerActual == self.GroupBWinner! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupBRunnerUPActual == self.GroupBRunnerUP! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupBThirdPlace = results.valueForKey("GroupBThirdPlace") as! String
      if groupBThirdPlace == self.GroupBThirdPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupBFourthPlace = results.valueForKey("GroupBFourthPlace") as! String
      if groupBFourthPlace == self.GroupBFourthPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
    }
    
    let groupCWinnerActual = results.valueForKey("GroupCWinner") as! String
    let groupCRunnerUPActual = results.valueForKey("GroupCRunnerUP") as! String

    if groupCWinnerActual != "GroupCWinner" {
      let groupCThirdPlace = results.valueForKey("GroupCThirdPlace") as! String
      let groupCFourthPlace = results.valueForKey("GroupCFourthPlace") as! String
      
      if groupCWinnerActual == self.GroupCWinner! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupCRunnerUPActual == self.GroupCRunnerUP! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupCThirdPlace == self.GroupCThirdPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupCFourthPlace == self.GroupCFourthPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      
    }
 
    
    let groupDWinnerActual = results.valueForKey("GroupDWinner") as! String
    let groupDRunnerUPActual = results.valueForKey("GroupDRunnerUP") as! String

    if groupDWinnerActual != "GroupDWinner" {
     
      if groupDWinnerActual == self.GroupDWinner! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupDThirdPlace = results.valueForKey("GroupDThirdPlace") as! String
      let groupDFourthPlace = results.valueForKey("GroupDFourthPlace") as! String
      
      if groupDRunnerUPActual == self.GroupDRunnerUP! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupDThirdPlace == self.GroupDThirdPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupDFourthPlace == self.GroupDFourthPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      
    }
    
    //create an array of quarterfinalists
    //create an array of results quarterfinalists
    
    let actualQuarterFinalists = NSMutableArray()
    
    if groupAWinnerActual != "GroupAWinner" {
      actualQuarterFinalists.addObject(groupAWinnerActual)
    }
    
    if groupBWinnerActual != "GroupBWinner" {
      actualQuarterFinalists.addObject(groupBWinnerActual)
    }
    
    if groupCWinnerActual != "GroupCWinner" {
      actualQuarterFinalists.addObject(groupCWinnerActual)
    }
    if groupDWinnerActual !=  "GroupDWinner"{
      actualQuarterFinalists.addObject(groupDWinnerActual)
    }
    
    if groupARunnerUPActual != "GroupARunnerUP"  {
      actualQuarterFinalists.addObject(groupARunnerUPActual)
    }
    
    if groupBRunnerUPActual != "GroupBRunnerUP" {
      actualQuarterFinalists.addObject(groupBRunnerUPActual)
    }
    
    if groupCRunnerUPActual != "GroupCRunnerUP" {
      actualQuarterFinalists.addObject(groupCRunnerUPActual)
    }
    
    if groupDRunnerUPActual != "GroupDRunnerUP" {
      actualQuarterFinalists.addObject(groupDRunnerUPActual)
    }
    
    let userQuarterFinalistPicks = [self.GroupAWinner, self.GroupARunnerUP, self.GroupBWinner, self.GroupBRunnerUP, self.GroupCWinner, self.GroupCRunnerUP, self.GroupDWinner, self.GroupDRunnerUP]
    
   
    for team in actualQuarterFinalists {
      for pick in userQuarterFinalistPicks {
        if pick! == team as! String {
          pointsScored = pointsScored + quarterFinalsCorrectPick
          break
        }
      }
    }
    
    
    let semifinalistTeam1Actual = results.valueForKey("SemifinalistTeam1") as! String
    let semifinalistTeam2Actual = results.valueForKey("SemifinalistTeam2") as! String
    let semifinalistTeam3Actual = results.valueForKey("SemifinalistTeam3") as! String
    let semifinalistTeam4Actual = results.valueForKey("SemifinalistTeam4") as! String
    
    let actualSemifinalists = NSMutableArray()
    if semifinalistTeam1Actual != "SemifinalistTeam1"  {
      actualSemifinalists.addObject(semifinalistTeam1Actual)
    }
    
    if semifinalistTeam2Actual != "SemifinalistTeam2" {
      actualSemifinalists.addObject(semifinalistTeam2Actual)
    }
    if semifinalistTeam3Actual != "SemifinalistTeam3" {
      actualSemifinalists.addObject(semifinalistTeam3Actual)
    }
    
    if semifinalistTeam4Actual != "SemifinalistTeam4" {
      actualSemifinalists.addObject(semifinalistTeam4Actual)
    }
    
    let userSemifinalistPicks = [self.SemifinalistTeam1, self.SemifinalistTeam2, self.SemifinalistTeam3, self.SemifinalistTeam4]
    var count = 0
    for team in actualSemifinalists {
      for pick in userSemifinalistPicks {
        //print("actual team : \(team)")
        //print("pick: \(pick)")
        
        if pick! == team as! String {
          pointsScored = pointsScored + semiFinalsCorrectPick
          count+=1
          break
        }
      }
    }
    
    //print(count)
    let finalistTeam1Actual = results.valueForKey("FinalistTeam1") as! String
    let finalistTeam2Actual = results.valueForKey("FinalistTeam2") as! String
    let finalistsActual = NSMutableArray()
    let userPickedFinalists = [self.FinalistTeam1, self.FinalistTeam2]
    
    if finalistTeam1Actual != "FinalistTeam1" {
      finalistsActual.addObject(finalistTeam1Actual)
    }
    if finalistTeam2Actual != "FinalistTeam2" {
      finalistsActual.addObject(finalistTeam2Actual)
    }
    for actualFinalist in finalistsActual {
      for pick in userPickedFinalists {
        //print("pick: \(pick) actual: \(actualFinalist)")
        if actualFinalist as? String == pick {
          pointsScored = pointsScored + finalsCorrectPick
        }
      }
    }
    
    let champion = results.valueForKey("Champion") as! String
    if champion == self.Champion! {
      pointsScored = pointsScored + championCorrectPick
    }
    self.points = pointsScored as NSNumber
  }
  
  func addPointsForStageTeams(stageTeams : NSArray) {
    
  }
  
  
  
  
  

}