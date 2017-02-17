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
    
    fileprivate var _BASE_REF = Firebase(url: "\(BASE_URL)")
    fileprivate var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    fileprivate var _CHALLENGEGROUPS_REF = Firebase(url: "\(BASE_URL)/ChallengeGroups")
    typealias CompletionHandler = (_ success:Bool) -> Void


    //private var _JOKE_REF = Firebase(url: "\(BASE_URL)/jokes")
    
    var BASE_REF: Firebase {
        return _BASE_REF!
    }

    var USER_REF: Firebase {
        return _USER_REF!
    }
  
    var CHALLENGEGROUPS_REF: Firebase {
      return _CHALLENGEGROUPS_REF!
    }

    var CURRENT_USER_REF: Firebase {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").child(byAppendingPath: "users").child(byAppendingPath: userID)
        
        return currentUser!
    }
    
    func createNewAccount(_ uid: String, user: Dictionary<String, String>, completionHandler: @escaping CompletionHandler) {

        let ref = USER_REF.child(byAppendingPath: "\(USER_REF.authData.uid)")
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot?.exists())!{
                //print("user exists")
                let flag = true
                completionHandler(flag)
            } else {
                //print("user doesnt exist")
                let flag = true
                completionHandler(flag)
                self.USER_REF.child(byAppendingPath: uid).setValue(user)
            }
            }) { (error) in
                //print(error.localizedDescription)
                let flag = false
                completionHandler(flag)
        }
    }
  
  func updateCurrentUserWithGroupID(_ groupID: String, groupImage: String, groupName: String, createdBy: String, completionHandler: @escaping CompletionHandler) {
    let ref = Firebase(url: "\(CURRENT_USER_REF)")
    ref?.observeSingleEvent(of: FEventType.value, with: { (snapshot) in
      let newGroup = ref?.childByAutoId()
      let newGroupDetails = ["groupID": groupID, "groupImage":groupImage, "groupName": groupName, "createdBy": createdBy]
      newGroup?.setValue(newGroupDetails)
      let flag = true
      completionHandler(flag)
      
      }) { (error) in
        let flag = false
        completionHandler(flag)

      }
    
    }
  
  
  
  
 
}

