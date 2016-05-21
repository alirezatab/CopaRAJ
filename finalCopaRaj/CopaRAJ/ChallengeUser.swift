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
  
  
  
  
  

}