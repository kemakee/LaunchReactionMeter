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
import AudioToolbox


protocol MultiPeerCommunicationManagerDelegate : NSObjectProtocol{
    func peersChanged(peers: [MCPeerID])
    func invitationReceived(fromPeer: String)
    func connectedWithPeer(_ peerID: MCPeerID)
}

class MultiPeerCommunicationManager: NSObject {

    
    private let serviceType = "launch-meter"
    private let myPeerdID = MCPeerID(displayName: UIDevice.current.name)
    
    let advertiser : MCNearbyServiceAdvertiser
    let browser : MCNearbyServiceBrowser
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerdID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    private var foundPeers = [MCPeerID]()
    weak var delegate : MultiPeerCommunicationManagerDelegate?
    
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    override init() {
        self.advertiser = MCNearbyServiceAdvertiser(peer: myPeerdID, discoveryInfo: nil, serviceType: serviceType)
        self.browser = MCNearbyServiceBrowser(peer: myPeerdID, serviceType: serviceType)
        super.init()
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
        self.browser.delegate = self
        self.browser.startBrowsingForPeers()
        
    }
    
    
    
}

extension MultiPeerCommunicationManager : MCNearbyServiceAdvertiserDelegate
{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Unable to start advertising, error: \(error)" )
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        delegate?.invitationReceived(fromPeer: peerID.displayName)
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
        
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            delegate?.connectedWithPeer(peerID)
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
        
        print("peer \(peerID) didChangeState to : \(state)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        print("recieved from \(peerID), data: \(data)")
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
        let str = String(data: data, encoding: .utf8)!
//        print(str)
//        print(dateFormatter.string(from: date))
        let startdate = dateFormatter.date(from: str)!
        
        DispatchQueue.main.async {
            let offset = TimeManager.shared.calculateOffsetFromNetActualTime(date: startdate)
            Timer.scheduledTimer(timeInterval: offset, target: self, selector: #selector(self.timerFired), userInfo: self, repeats: false)
        }
        
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
    
    @objc func timerFired() {
        //        print("------------------------------------------")
        //        print(Date().dateWithMillisecInString())
        //        print(TimeMnanager.shared.now().dateWithMillisecInString())
        //
        //        if let date = Clock.now {
        //            print(date.dateWithMillisecInString())
        //        }
        
        print(TimeManager.shared.now().dateWithMillisecInString())
        AudioServicesPlaySystemSound(1322)
        
    }
    
}


