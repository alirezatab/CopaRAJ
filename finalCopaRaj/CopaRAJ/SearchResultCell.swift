//
//  SearchResultCell.swift
//  CopaRAJ
//
//  Created by Richard Velazquez on 5/22/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import Foundation

  protocol SearchResultCellDelegate {
    
    func userDidRequestJoin(sender: UIButton)

  }


class SearchResultCell: GroupHomeCell {
  
  @IBOutlet weak var alreadyAMemberLabel: UILabel!
  @IBOutlet weak var joinButton: UIButton!
  
  var delegate:SearchResultCellDelegate? = nil
  

  
  
  @IBAction func onJoinButtonPressed(sender: UIButton) {
      delegate?.userDidRequestJoin(sender)
  }

}