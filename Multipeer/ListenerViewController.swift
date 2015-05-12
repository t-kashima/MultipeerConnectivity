//
//  ViewController.swift
//  Multipeer
//
//  Created by Kashima Takumi on 2015/05/11.
//  Copyright (c) 2015年 UNUUU FOUNDATION. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ListenerViewController: UIViewController,
                      MCBrowserViewControllerDelegate,
                      MCSessionDelegate {

    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var session : MCSession!
    var peerID: MCPeerID!

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showBrowse(sender: AnyObject) {
        // Show the browser view controller
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!)  {
        // Called when the browser view controller is dismissed (ie the Done 
        // button was tapped)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!)  {
        // Called when the browser view controller is cancelled
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!)  {
        // Called when a peer sends an NSData to us
        
        // This needs to run on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            let title = NSString(data: data, encoding: NSUTF8StringEncoding)
            if title == nil {
                return
            }
            self.label.text = title! as String
        }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol 
    // requires that we implement them.
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {
            
        // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!)  {
        // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
        withName streamName: String!, fromPeer peerID: MCPeerID!)  {
        // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState)  {
        // Called when a connected peer changes state (for example, goes offline)

    }
}

