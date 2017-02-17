//
//  HowToPlayVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 6/1/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class HowToPlayVC: UIViewController {
    
    @IBOutlet weak var RulesTextView: UITextView!

    @IBOutlet weak var rulesInGroupHomeTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.RulesTextView?.isScrollEnabled = false
        
        self.rulesInGroupHomeTextView?.isScrollEnabled = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        RulesTextView?.isScrollEnabled = true
    
        self.rulesInGroupHomeTextView?.isScrollEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
