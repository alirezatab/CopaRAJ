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
  var imageName : String?
  var createdBy : NSString?
  var groupID : NSString?
  var members : NSMutableArray?
  var userIsAlreadyMember : Bool?
  var userHasMadePicks : Bool?

  
  override init() {
    super.init()
  }
 
  
  init(name: NSString, password: NSString, imageName: String) {
    self.name = name
    self.password = password
    self.imageName = imageName
    self.members  = NSMutableArray()
  }
  
  init(name: NSString, imageName: String, createdBy : NSString, groupID: NSString) {
    self.name = name
    self.imageName = imageName
    self.createdBy = createdBy
    self.groupID = groupID
    self.members = NSMutableArray()
  }
  
  func updateGroupWithDictionary(_ dictionary : NSDictionary, currentResults : NSDictionary) {
    //print(currentResults)
    self.members = NSMutableArray()
    for id in dictionary {
      let idKey = id.key as! String
      if idKey  == "password" {
        self.password = id.value as? NSString
      } else if idKey == "createdBy" {
        self.createdBy = id.value as! String as NSString?
      } else if idKey != "imageName" && idKey != "name" && idKey != "admin" && idKey != "password" && idKey != "createdBy" {
        let member = self.createMemberforGroup(id.value as! NSDictionary, key: idKey, tournyResults: currentResults)
        self.members?.add(member)
      }
    }
  }
  
  func createMemberforGroup(_ dictionary: NSDictionary, key : String, tournyResults : NSDictionary) -> ChallengeUser {
    let user = ChallengeUser()
    user.Champion = dictionary.value(forKey: "Champion") as? String
    user.FinalistTeam1 = dictionary.value(forKey: "FinalistTeam1") as? String
    user.FinalistTeam2 = dictionary.value(forKey: "FinalistTeam2") as? String
    
    user.GroupAFourthPlace = dictionary.value(forKey: "GroupAFourthPlace") as? String
    user.GroupARunnerUP = dictionary.value(forKey: "GroupARunnerUP") as? String
    user.GroupAThirdPlace = dictionary.value(forKey: "GroupAThirdPlace") as? String
    user.GroupAWinner = dictionary.value(forKey: "GroupAWinner") as? String
    
    user.GroupBFourthPlace = dictionary.value(forKey: "GroupBFourthPlace") as? String
    user.GroupBRunnerUP = dictionary.value(forKey: "GroupBRunnerUP") as? String
    user.GroupBThirdPlace = dictionary.value(forKey: "GroupBThirdPlace") as? String
    user.GroupBWinner = dictionary.value(forKey: "GroupBWinner") as? String
    
    user.GroupCFourthPlace = dictionary.value(forKey: "GroupCFourthPlace") as? String
    user.GroupCRunnerUP = dictionary.value(forKey: "GroupCRunnerUP") as? String
    user.GroupCThirdPlace = dictionary.value(forKey: "GroupCThirdPlace") as? String
    user.GroupCWinner = dictionary.value(forKey: "GroupCWinner") as? String
    
    user.GroupDFourthPlace = dictionary.value(forKey: "GroupDFourthPlace") as? String
    user.GroupDRunnerUP = dictionary.value(forKey: "GroupDRunnerUP") as? String
    user.GroupDThirdPlace = dictionary.value(forKey: "GroupDThirdPlace") as? String
    user.GroupDWinner = dictionary.value(forKey: "GroupDWinner") as? String
    
    user.SemifinalistTeam1 = dictionary.value(forKey: "SemifinalistTeam1") as? String
    user.SemifinalistTeam2 = dictionary.value(forKey: "SemifinalistTeam2") as? String
    user.SemifinalistTeam3 = dictionary.value(forKey: "SemifinalistTeam3") as? String
    user.SemifinalistTeam4 = dictionary.value(forKey: "SemifinalistTeam4") as? String
    
    user.firstName = dictionary.value(forKey: "firstName") as? String
    user.lastName = dictionary.value(forKey: "lastName") as? String
    
    //self.calculatePointsUser
    
    let userID = UserDefaults.standard.value(forKey: "uid") as! String
    if userID == key {
      self.userIsAlreadyMember = true
      if user.Champion == "" {
        self.userHasMadePicks = false
      } else {
        self.userHasMadePicks = true
      }
    }
    user.updatePointsWithResults(tournyResults)
    
    return user
  }
  
//  func calculatePointsForUser(<#parameters#>) -> <#return type#> {
//    <#function body#>
//  }
//  
  
}

