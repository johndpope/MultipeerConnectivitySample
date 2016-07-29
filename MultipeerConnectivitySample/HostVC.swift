//
//  HostVC.swift
//  MultipeerConnectivitySample
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class HostVC: UIViewController {

    let serviceType = "sample"
    let peerId = MCPeerID(displayName: "host")
    
    var session: MCSession!
    var browserVC: MCBrowserViewController! // 簡単
//    var serviceBrowser: MCNearbyServiceBrowser!   // 細かい制御
    
    var firstAppearingFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppearingFlag {
            firstAppearingFlag = false
            presentMCBrowser()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


/**
 *  Actions -------------------
 */
extension HostVC {
    func setUp() {
        session = MCSession(peer: peerId)
        session.delegate = self
//        serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceType)
//        serviceBrowser.delegate = self
//        serviceBrowser.startBrowsingForPeers()
    }
    
    func presentMCBrowser() {
        let browserVC = MCBrowserViewController(serviceType: serviceType, session: session)
        browserVC.delegate = self
        presentViewController(browserVC, animated: true, completion: nil)
    }
}


/**
 *  MCSession delegate -------------------
 */
extension HostVC: MCSessionDelegate {
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case .Connected:
            print("MCSessionState.Connected")
        case .Connecting:
            print("MCSessionState.Connecting")
        case .NotConnected:
            print("MCSessionState.NotConnected")
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        print("Host did receive data from: \(peerID)")
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
 
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Did receive stream '\(streamName)' from \(peerID)")
        TDAudioPlayer.sharedAudioPlayer().loadAudioFromStream(stream)
        TDAudioPlayer.sharedAudioPlayer().play()
    }
}


/**
 *  MCNearbyServiceBrowser delegate -------------------
 */
//extension HostVC: MCNearbyServiceBrowserDelegate {
//    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        print("Founded: \(peerID)")
//    }
//
//    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        print("Losted: \(peerID)")
//    }
//}


/**
 *  MCBrowserViewController delegate -------------------
 */
extension HostVC: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        browserViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        browserViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
