//
//  ChallengeGroup.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/12/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

class ChallengeGroup: NSObject {
  var name : NSString?
  var password : NSString?
  var imageName : NSString?
  var createdBy : NSString?
  var groupID : NSString?
  var members : NSMutableArray?
  
  
  
  init(name: NSString, password: NSString, imageName: NSString) {
    self.name = name
    self.password = password
    self.imageName = imageName
    self.members  = NSMutableArray()
  }
  
  init(name: NSString, imageName: NSString, createdBy : NSString, groupID: NSString) {
    self.name = name
    self.imageName = imageName
    self.createdBy = createdBy
    self.groupID = groupID
    self.members = NSMutableArray()
  }
  
  func updateGroupWithDictionary(dictionary : NSDictionary) {
    self.members = NSMutableArray()
    for id in dictionary {
      let idKey = id.key as! String
      if idKey  == "password" {
        self.password = id.value as? NSString
      } else if idKey != "imageName" && idKey != "name" && idKey != "admin" && idKey != "password" {
        let member = self.createMemberforGroup(id.value as! NSDictionary)
        self.members?.addObject(member)
      }
    }
  }
  
  func createMemberforGroup(dictionary: NSDictionary) -> ChallengeUser {
    let user = ChallengeUser()
    user.Champion = dictionary.valueForKey("Champion") as? String
    user.FinalistTeam1 = dictionary.valueForKey("FinalistTeam1") as? String
    user.FinalistTeam2 = dictionary.valueForKey("FinalistTeam2") as? String
    
    user.GroupAFourthPlace = dictionary.valueForKey("GroupAFourthPlace") as? String
    user.GroupARunnerUP = dictionary.valueForKey("GroupARunnerUP") as? String
    user.GroupAThirdPlace = dictionary.valueForKey("GroupAThirdPlace") as? String
    user.GroupAWinner = dictionary.valueForKey("GroupAWinner") as? String
    
    user.GroupBFourthPlace = dictionary.valueForKey("GroupBFourthPlace") as? String
    user.GroupBRunnerUP = dictionary.valueForKey("GroupBRunnerUP") as? String
    user.GroupBThirdPlace = dictionary.valueForKey("GroupBThirdPlace") as? String
    user.GroupBWinner = dictionary.valueForKey("GroupBWinner") as? String
    
    user.GroupCFourthPlace = dictionary.valueForKey("GroupCFourthPlace") as? String
    user.GroupCRunnerUP = dictionary.valueForKey("GroupCRunnerUP") as? String
    user.GroupCThirdPlace = dictionary.valueForKey("GroupCThirdPlace") as? String
    user.GroupCWinner = dictionary.valueForKey("GroupCWinner") as? String
    
    user.GroupDFourthPlace = dictionary.valueForKey("GroupDFourthPlace") as? String
    user.GroupDRunnerUP = dictionary.valueForKey("GroupDRunnerUP") as? String
    user.GroupDThirdPlace = dictionary.valueForKey("GroupDThirdPlace") as? String
    user.GroupDWinner = dictionary.valueForKey("GroupDWinner") as? String
    
    user.SemifinalistTeam1 = dictionary.valueForKey("SemifinalistTeam1") as? String
    user.SemifinalistTeam2 = dictionary.valueForKey("SemifinalistTeam2") as? String
    user.SemifinalistTeam3 = dictionary.valueForKey("SemifinalistTeam3") as? String
    user.SemifinalistTeam4 = dictionary.valueForKey("SemifinalistTeam4") as? String
    
    user.firstName = dictionary.valueForKey("firstName") as? String
    user.lastName = dictionary.valueForKey("lastName") as? String
    
    return user
  }
  
  
}

