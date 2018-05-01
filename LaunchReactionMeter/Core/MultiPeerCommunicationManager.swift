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
    func lostPeer(_ peerID : MCPeerID)
}

class MultiPeerCommunicationManager: NSObject {

    
    private let serviceType = "launch-meter"
    private let myPeerdID = MCPeerID(displayName: UIDevice.current.name)
    
    var advertiser : MCNearbyServiceAdvertiser!
    var browser : MCNearbyServiceBrowser!
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerdID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    private var foundPeers = [MCPeerID]()
    weak var delegate : MultiPeerCommunicationManagerDelegate?
    
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    init(userType : UserType) {
        super.init()
        switch userType {
        case .athlete:
            self.advertiser = MCNearbyServiceAdvertiser(peer: myPeerdID, discoveryInfo: nil, serviceType: serviceType)
            self.advertiser.delegate = self
            self.advertiser.startAdvertisingPeer()
            break;
        case .coach:
            self.browser = MCNearbyServiceBrowser(peer: myPeerdID, serviceType: serviceType)
            self.browser.delegate = self
            self.browser.startBrowsingForPeers()
            break;

        default:
            break;
        }
        
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
        delegate?.lostPeer(peerID)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
        let str = String(data: data, encoding: .utf8)!
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

        
        print(TimeManager.shared.now().dateWithMillisecInString())
        AudioServicesPlaySystemSound(1322)
        blinkScreen()
        
    }
    
    func blinkScreen(){
        var wnd = UIApplication.shared.keyWindow;
        var v = UIView(frame: CGRect(x:0, y:0, width: wnd!.frame.size.width, height:wnd!.frame.size.height))
        wnd!.addSubview(v);
        v.backgroundColor = UIColor.white
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1.0)
        v.alpha = 0.0;
        UIView.commitAnimations();
    }
    
}


