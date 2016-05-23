//
//  SearchResultGroup.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/22/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

class SearchResultGroup : ChallengeGroup {
  var uniqueID : String?
  
  override init() {
    super.init()
  }
  
  func returnGroupWithResult(newResult: NSDictionary, groupID: String)  {
    self.uniqueID = groupID
    self.userIsAlreadyMember = false

    
    for (key, value) in newResult {
      if key as! String == "password" {
        self.password = value as? NSString
      } else if key as! String == "imageName" {
        self.imageName = value as? NSString
      } else if key as! String == "name" {
        self.name = value as? NSString
      } else if key as! String == "createdBy" {
        self.createdBy = value as? NSString
      }else if key as! String == "admin"{
      } else {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        if userID == key as! String {
          self.userIsAlreadyMember = true
        }
        print("\(key) is key \(value) is value")
      }
    }
  }

  
  
}