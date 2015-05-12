//
//  ViewController.swift
//  Multipeer
//
//  Created by Kashima Takumi on 2015/05/11.
//  Copyright (c) 2015年 UNUUU FOUNDATION. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPlayer(sender: AnyObject) {
        performSegueWithIdentifier("goToPlayerView", sender: nil)
    }
    
    
    @IBAction func didTapListener(sender: AnyObject) {
        performSegueWithIdentifier("goToListenerView", sender: nil)
    }
}

