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
  
  init(name: NSString, password: NSString, imageName: NSString) {
    self.name = name
    self.password = password
    self.imageName = imageName
  }
}

