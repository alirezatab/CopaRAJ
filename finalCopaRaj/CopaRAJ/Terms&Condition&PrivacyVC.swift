//
//  Terms&Condition&PrivacyVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 6/2/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class Terms_Condition_PrivacyVC: UIViewController {

    @IBOutlet weak var termTexView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.termTexView?.isScrollEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        self.termTexView?.isScrollEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
