//
//  ViewController.swift
//  Multipeer
//
//  Created by Kashima Takumi on 2015/05/11.
//  Copyright (c) 2015年 UNUUU FOUNDATION. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import MediaPlayer

class PlayerViewController: UIViewController,
                            MCSessionDelegate {

    let serviceType = "LCOC-Chat"
    
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    var player: MPMusicPlayerController!

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 複数通信の設定をする
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()

        // 再生中の曲を表示する
        self.player = MPMusicPlayerController()
        self.player.beginGeneratingPlaybackNotifications()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNowPlayingItemChanged:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: nil)
        
        self.label.text = self.getNowPlayMusicTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 曲のタイトルを他の人に送る
    func sendSongTitle() {
        if 0 >= self.session.connectedPeers.count {
            return
        }
        
        let title = self.getNowPlayMusicTitle()
        let data = title.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        var error : NSError?
        self.session.sendData(data, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Reliable, error: &error)
        
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
        
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!)  {
        // Called when a peer sends an NSData to us
        
        // This needs to run on the main queue
        dispatch_async(dispatch_get_main_queue()) {
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
        switch state {
        case MCSessionState.Connected:
            self.sendSongTitle()
        default:
            return
        }
    }
    
    // 再生中の曲を取得する
    func getNowPlayMusicTitle() -> String {
        var item = self.player.nowPlayingItem
        var title = item.valueForProperty(MPMediaItemPropertyTitle) as? String
        if title == nil {
            title = "No title"
        }
        return title!
    }
    
    // 再生中の曲が変わった時に呼ばれる
    func onNowPlayingItemChanged(notification: NSNotification) {
        self.label.text = self.getNowPlayMusicTitle()
    
        self.sendSongTitle()
    }
}

