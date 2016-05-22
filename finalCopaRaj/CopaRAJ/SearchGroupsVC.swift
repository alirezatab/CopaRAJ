//
//  SearchGroupsVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/21/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

class SearchGroupsVC: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!
  
  
  var groupsFromSearchResults : NSMutableArray?
  
  
  override func viewDidLoad() {
    self.activityIndicator.hidden = true
    self.groupsFromSearchResults = NSMutableArray()

    //self.tableView.hidden = true
    
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    self.activityIndicator.hidden = false
    self.activityIndicator.startAnimating()
    self.activityIndicator.hidesWhenStopped = true
    self.groupsFromSearchResults = NSMutableArray()
    self.searchGroupsWith(searchBar.text!)
  }
  

  func searchGroupsWith(text:String) {
    let ref = DataService.dataService.CHALLENGEGROUPS_REF
    ref.queryOrderedByChild("name").queryStartingAtValue(text).queryLimitedToFirst(10).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) in
      if let newResults = snapshot.value as? NSDictionary {
        for (key, groupDictionary) in newResults {
          print(groupDictionary)
          let newSearchResultGroup = SearchResultGroup()
          newSearchResultGroup.returnGroupWithResult(groupDictionary as! NSDictionary, groupID: key as! String)
          if ((newSearchResultGroup.name?.containsString(text)) == true){
          self.groupsFromSearchResults?.insertObject(newSearchResultGroup, atIndex: 0)
          } else {
            self.groupsFromSearchResults?.addObject(newSearchResultGroup)
          }
          print(self.groupsFromSearchResults?.count)
        }
      }
      self.tableView.reloadData()      
      
      }) { (error) in
        print(error.localizedDescription)
        self.searchGroupsWith(text)
    }

   
  }
  

  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("groupHomeCell") as! SearchResultCell
    let challengeGroup = self.groupsFromSearchResults?.objectAtIndex(indexPath.row) as! SearchResultGroup
    cell.groupImageView.image = UIImage.init(named: challengeGroup.imageName as! String)
    if let createdBy = challengeGroup.createdBy as? String {
      cell.ptsLabel.text = "created by \(createdBy)"
    } else {
      cell.ptsLabel.text = ""
    }
    
    cell.groupNameLabel.text = challengeGroup.name as? String
    if challengeGroup.userIsAlreadyMember == true {
      cell.joinButton.enabled = false
      cell.joinButton.hidden = true
      cell.alreadyAMemberLabel.hidden = false
    } else {
      cell.joinButton.enabled = true
      cell.joinButton.hidden = false
      cell.alreadyAMemberLabel.hidden = true

    }
  
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.groupsFromSearchResults!.count
  }

}
