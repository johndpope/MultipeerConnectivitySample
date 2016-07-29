//
//  ClientVC.swift
//  MultipeerConnectivitySample
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class ClientVC: UIViewController {

    let serviceType = "sample"
    let peerId: MCPeerID = {
        return MCPeerID(displayName: "client:\(UIDevice.currentDevice().name)")
    }()
    
    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    
    var stream: NSOutputStream?
    var assetReader: AVAssetReader?
    var assetOutput: AVAssetReaderTrackOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


/**
 *  Actions -------------------
 */
extension ClientVC {
    func setUp() {
        session = MCSession(peer: peerId)
        session.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    func sendStringData(peerID: MCPeerID) {
        let data = "Hello world.".dataUsingEncoding(NSUTF8StringEncoding)!
        
        do {
            try session.sendData(data, toPeers: [peerID], withMode: .Reliable)
            print("Sended text data.")
            
        } catch let error {
            print("Send text data error: ", error)
        }
    }
    
    func  streamMusicData(peerID: MCPeerID) {
        let filePath = NSBundle.mainBundle().pathForResource("sample", ofType: "mp3")!
        let audioURL = NSURL(fileURLWithPath: filePath)

        do {
            stream = try session.startStreamWithName("musicStream", toPeer: peerID)
            let outputStreamer = TDAudioOutputStreamer(outputStream: stream)
            outputStreamer.streamAudioFromURL(audioURL)
            outputStreamer.start()
            print("Sending music data.")

        } catch let error {
            print("Send data error: ", error)
        }
    }
}


/**
 *  MCSession delegate -------------------
 */
extension ClientVC: MCSessionDelegate {
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case .Connected:
            print("MCSessionState.Connected: \(peerID)")
            if peerID.displayName != "host" { return }
            streamMusicData(peerID)

        case .Connecting:
            print("MCSessionState.Connecting")
        case .NotConnected:
            print("MCSessionState.NotConnected")
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        print("Client did receive data from: \(peerID)")
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
 
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
}


/**
 *  MCNearbyServiceAdvertiser delegate -------------------
 */
extension ClientVC: MCNearbyServiceAdvertiserDelegate {
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        print("Invitation from: \(peerID)")
        invitationHandler(true, session)
    }
}