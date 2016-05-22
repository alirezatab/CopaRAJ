//
//  SearchGroupsVC.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/21/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

class SearchGroupsVC: UIViewController, UISearchBarDelegate {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  
  override func viewDidLoad() {
    self.activityIndicator.hidden = true
    
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    self.activityIndicator.hidden = false
    self.activityIndicator.startAnimating()
    self.activityIndicator.hidesWhenStopped = true
    self.seachGroupsWith(searchBar.text!)
  }
  

  func seachGroupsWith(text:String) {
  
  }
  

}
