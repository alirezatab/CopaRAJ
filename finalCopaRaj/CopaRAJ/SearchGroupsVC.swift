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
    self.tableView.hidden = true
    
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    self.activityIndicator.hidden = false
    self.activityIndicator.startAnimating()
    self.activityIndicator.hidesWhenStopped = true
    self.searchGroupsWith(searchBar.text!)
  }
  

  func searchGroupsWith(text:String) {
    let ref = DataService.dataService.CHALLENGEGROUPS_REF
    ref.queryOrderedByChild("name").queryStartingAtValue(text).queryLimitedToFirst(25).observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) in
      if let newResults = snapshot.value as? NSDictionary {
        self.updateResultsWith(newResults)
      }
      print(snapshot.value)
      
      }) { (error) in
        print(error.localizedDescription)
        self.searchGroupsWith(text)
    }
  }
  
  func updateResultsWith(newResults: NSDictionary) {
    self.tableView.reloadData()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("groupHomeCell") as! SearchResultCell
    let challengeGroup = self.groupsFromSearchResults?.objectAtIndex(indexPath.row) as! SearchResultGroup
    cell.groupImageView.image = UIImage.init(named: challengeGroup.name as! String)
    cell.groupNameLabel.text = challengeGroup.name as? String
    if challengeGroup.userIsAlreadyMember == true {
      cell.joinButton.enabled = false
      cell.joinButton.hidden = true
    } else {
      cell.joinButton.enabled = true
      cell.joinButton.hidden = false
    }
  
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = self.groupsFromSearchResults?.count {
      return count
    } else {
      return 0
    }
  }

}
