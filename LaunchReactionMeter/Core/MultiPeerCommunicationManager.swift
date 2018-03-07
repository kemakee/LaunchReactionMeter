//
//  MultiPeerCommunicationManager.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 03. 07..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

protocol MultiPeerCommunicationManagerDelegate : NSObjectProtocol{
    func peersChanged(peers: [MCPeerID])
}

class MultiPeerCommunicationManager: NSObject {

    
    private let serviceType = "launch-meter"
    private let myPeerdID = MCPeerID(displayName: UIDevice.current.name)
    
    private let advertiser : MCNearbyServiceAdvertiser
    private let browser : MCNearbyServiceBrowser
    private var session : MCSession!
    
    private var foundPeers = [MCPeerID]()
    weak var delegate : MultiPeerCommunicationManagerDelegate?
    
    override init() {
        self.advertiser = MCNearbyServiceAdvertiser(peer: myPeerdID, discoveryInfo: nil, serviceType: serviceType)
        self.browser = MCNearbyServiceBrowser(peer: myPeerdID, serviceType: serviceType)
        super.init()
        session = MCSession(peer: myPeerdID, securityIdentity: nil, encryptionPreference: .required)
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
        self.browser.delegate = self
        self.browser.startBrowsingForPeers()
        
    }
    
    func getBrowser() -> MCNearbyServiceBrowser
    {
        return browser
    }
    
    
    

}



extension MultiPeerCommunicationManager : MCNearbyServiceAdvertiserDelegate
{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Unable to start advertising, error: \(error)" )
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Recieved invitation from peer: \(peerID)")
    }
}

extension MultiPeerCommunicationManager : MCNearbyServiceBrowserDelegate
{
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID)")
        
        var index : Int = 0
    
        for aPeer in foundPeers{
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
            index += 1
        }
        delegate?.peersChanged(peers: foundPeers)
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Unable to start browsing, error: \(error)")
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found peer: \(peerID)")
        foundPeers.append(peerID)
        delegate?.peersChanged(peers: foundPeers)
        
    }
    
}

extension MultiPeerCommunicationManager : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState to : \(state)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("recieved from \(peerID), data: \(data)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("stream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}


