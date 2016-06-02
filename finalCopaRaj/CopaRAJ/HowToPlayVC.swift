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
        
        self.RulesTextView?.scrollEnabled = false
        
        self.rulesInGroupHomeTextView?.scrollEnabled = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        RulesTextView?.scrollEnabled = true
    
        self.rulesInGroupHomeTextView?.scrollEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
