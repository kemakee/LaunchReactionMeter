//
//  ViewController.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 02. 26..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ViewController: UIViewController, MultiPeerCommunicationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
 
    
    
    private var peerList: UITableView!
    private let cellIdentifier = "cellIdentifier"
    private var peers = [MCPeerID]()

    let communication = MultiPeerCommunicationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        
        peerList = UITableView()
        peerList.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        peerList.dataSource = self
        peerList.delegate = self
        peerList.separatorStyle = .singleLineEtched
        peerList.register(SingleLineTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        peerList.alwaysBounceVertical = true
        communication.delegate = self
        self.view.addSubview(peerList)
    
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return peers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SingleLineTableViewCell
        let configCell = ConfigurationSingeLineTableViewCell(deviceName: String(describing: peers[indexPath.row].displayName))
        cell.configure(configCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.scale(60)
    }
    
    
    func peersChanged(peers: [MCPeerID]) {
        self.peers = peers
        peerList.reloadData()

    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

