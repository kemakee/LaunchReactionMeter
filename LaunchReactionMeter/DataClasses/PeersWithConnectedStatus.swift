//
//  PeersWithConnectedStatus.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 17..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PeersWithConnectedStatus: NSObject {
    
    var peer : MCPeerID!
    var isConnected : Bool!
    
    init(peer : MCPeerID, isConnected : Bool = false) {
        super.init()
        self.peer = peer
        self.isConnected = isConnected
    }

}
