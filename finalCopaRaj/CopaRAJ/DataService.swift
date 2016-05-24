//
//  DataService.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/14/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

let BASE_URL = "https://fiery-inferno-5799.firebaseio.com"

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _CHALLENGEGROUPS_REF = Firebase(url: "\(BASE_URL)/ChallengeGroups")
    typealias CompletionHandler = (success:Bool) -> Void


    //private var _JOKE_REF = Firebase(url: "\(BASE_URL)/jokes")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }

    var USER_REF: Firebase {
        return _USER_REF
    }
  
    var CHALLENGEGROUPS_REF: Firebase {
      return _CHALLENGEGROUPS_REF
    }

    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>, completionHandler: CompletionHandler) {

        let ref = USER_REF.childByAppendingPath("\(USER_REF.authData.uid)")
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if (snapshot.exists()){
                print("user exists")
                let flag = true
                completionHandler(success: flag)
            } else {
                print("user doesnt exist")
                let flag = true
                completionHandler(success: flag)
                self.USER_REF.childByAppendingPath(uid).setValue(user)
            }
            }) { (error) in
                print(error.localizedDescription)
                let flag = false
                completionHandler(success: flag)
        }
    }
  
  func updateCurrentUserWithGroupID(groupID: String, groupImage: String, groupName: String, createdBy: String, completionHandler: CompletionHandler) {
    let ref = Firebase(url: "\(CURRENT_USER_REF)")
    ref.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) in
      let newGroup = ref.childByAutoId()
      let newGroupDetails = ["groupID": groupID, "groupImage":groupImage, "groupName": groupName, "createdBy": createdBy]
      newGroup.setValue(newGroupDetails)
      let flag = true
      completionHandler(success: flag)
      
      }) { (error) in
        let flag = false
        completionHandler(success: flag)

      }
    
    }
  
  
 
}

