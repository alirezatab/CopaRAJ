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
  
  func updatePointsWithResults (_ results : NSDictionary) {
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
    
    let groupAWinnerActual = results.value(forKey: "GroupAWinner") as! String
    let groupARunnerUPActual = results.value(forKey: "GroupARunnerUP") as! String

    if groupAWinnerActual != "GroupAWinner"{
      if groupAWinnerActual == self.GroupAWinner! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupARunnerUPActual  == self.GroupARunnerUP! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupAThirdPlace = results.value(forKey: "GroupAThirdPlace") as! String
      if groupAThirdPlace == self.GroupAThirdPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupAFourthPlace = results.value(forKey: "GroupAFourthPlace") as! String
      if groupAFourthPlace == self.GroupAFourthPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
    }
    
    
    let groupBWinnerActual = results.value(forKey: "GroupBWinner") as! String
    let groupBRunnerUPActual = results.value(forKey: "GroupBRunnerUP") as! String

    if groupBWinnerActual != "GroupBWinner" {
      if groupBWinnerActual == self.GroupBWinner! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      if groupBRunnerUPActual == self.GroupBRunnerUP! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupBThirdPlace = results.value(forKey: "GroupBThirdPlace") as! String
      if groupBThirdPlace == self.GroupBThirdPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupBFourthPlace = results.value(forKey: "GroupBFourthPlace") as! String
      if groupBFourthPlace == self.GroupBFourthPlace! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
    }
    
    let groupCWinnerActual = results.value(forKey: "GroupCWinner") as! String
    let groupCRunnerUPActual = results.value(forKey: "GroupCRunnerUP") as! String

    if groupCWinnerActual != "GroupCWinner" {
      let groupCThirdPlace = results.value(forKey: "GroupCThirdPlace") as! String
      let groupCFourthPlace = results.value(forKey: "GroupCFourthPlace") as! String
      
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
 
    
    let groupDWinnerActual = results.value(forKey: "GroupDWinner") as! String
    let groupDRunnerUPActual = results.value(forKey: "GroupDRunnerUP") as! String

    if groupDWinnerActual != "GroupDWinner" {
     
      if groupDWinnerActual == self.GroupDWinner! {
        pointsScored = pointsScored + firstRoundCorrectPick
      }
      let groupDThirdPlace = results.value(forKey: "GroupDThirdPlace") as! String
      let groupDFourthPlace = results.value(forKey: "GroupDFourthPlace") as! String
      
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
      actualQuarterFinalists.add(groupAWinnerActual)
    }
    
    if groupBWinnerActual != "GroupBWinner" {
      actualQuarterFinalists.add(groupBWinnerActual)
    }
    
    if groupCWinnerActual != "GroupCWinner" {
      actualQuarterFinalists.add(groupCWinnerActual)
    }
    if groupDWinnerActual !=  "GroupDWinner"{
      actualQuarterFinalists.add(groupDWinnerActual)
    }
    
    if groupARunnerUPActual != "GroupARunnerUP"  {
      actualQuarterFinalists.add(groupARunnerUPActual)
    }
    
    if groupBRunnerUPActual != "GroupBRunnerUP" {
      actualQuarterFinalists.add(groupBRunnerUPActual)
    }
    
    if groupCRunnerUPActual != "GroupCRunnerUP" {
      actualQuarterFinalists.add(groupCRunnerUPActual)
    }
    
    if groupDRunnerUPActual != "GroupDRunnerUP" {
      actualQuarterFinalists.add(groupDRunnerUPActual)
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
    
    
    let semifinalistTeam1Actual = results.value(forKey: "SemifinalistTeam1") as! String
    let semifinalistTeam2Actual = results.value(forKey: "SemifinalistTeam2") as! String
    let semifinalistTeam3Actual = results.value(forKey: "SemifinalistTeam3") as! String
    let semifinalistTeam4Actual = results.value(forKey: "SemifinalistTeam4") as! String
    
    let actualSemifinalists = NSMutableArray()
    if semifinalistTeam1Actual != "SemifinalistTeam1"  {
      actualSemifinalists.add(semifinalistTeam1Actual)
    }
    
    if semifinalistTeam2Actual != "SemifinalistTeam2" {
      actualSemifinalists.add(semifinalistTeam2Actual)
    }
    if semifinalistTeam3Actual != "SemifinalistTeam3" {
      actualSemifinalists.add(semifinalistTeam3Actual)
    }
    
    if semifinalistTeam4Actual != "SemifinalistTeam4" {
      actualSemifinalists.add(semifinalistTeam4Actual)
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
    let finalistTeam1Actual = results.value(forKey: "FinalistTeam1") as! String
    let finalistTeam2Actual = results.value(forKey: "FinalistTeam2") as! String
    let finalistsActual = NSMutableArray()
    let userPickedFinalists = [self.FinalistTeam1, self.FinalistTeam2]
    
    if finalistTeam1Actual != "FinalistTeam1" {
      finalistsActual.add(finalistTeam1Actual)
    }
    if finalistTeam2Actual != "FinalistTeam2" {
      finalistsActual.add(finalistTeam2Actual)
    }
    for actualFinalist in finalistsActual {
      for pick in userPickedFinalists {
        //print("pick: \(pick) actual: \(actualFinalist)")
        if actualFinalist as? String == pick {
          pointsScored = pointsScored + finalsCorrectPick
        }
      }
    }
    
    let champion = results.value(forKey: "Champion") as! String
    if champion == self.Champion! {
      pointsScored = pointsScored + championCorrectPick
    }
    self.points = pointsScored as NSNumber
  }
  
  func addPointsForStageTeams(_ stageTeams : NSArray) {
    
  }
  
  
  
  
  

}
