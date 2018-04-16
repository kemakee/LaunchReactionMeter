//
//  ViewController.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 02. 26..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Kronos
import AudioToolbox


class ViewController: BaseContentViewController, MultiPeerCommunicationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    func lostPeer(_ peerID: MCPeerID) {
        
    }
    
  
    
    
    private var peerList: UITableView!
    private var connectedList: UITableView!
    private let listCellIdentifier = "cellIdentifier"
    private let connectedListCellIdentifier = "cellIdentifier1"

    private var peers = [MCPeerID]()
    private var connectedPeers = [MCPeerID]()

    let communication = MultiPeerCommunicationManager(userType: .athlete)

    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.lightGray
        
        peerList = UITableView()
        peerList.frame = CGRect(x: 0, y: UIScreen.scale(20), width: self.view.frame.width, height: self.view.frame.height/2-UIScreen.scale(20))
        peerList.dataSource = self
        peerList.delegate = self
        peerList.separatorStyle = .singleLineEtched
        peerList.register(SingleLineTableViewCell.self, forCellReuseIdentifier: listCellIdentifier)
        peerList.alwaysBounceVertical = true
        
        let connectedLbl = UILabel()
        connectedLbl.frame = CGRect(x: UIScreen.scale(20), y: peerList.frame.maxY+UIScreen.scale(10), width: self.view.frame.width, height: UIScreen.scale(10))
        connectedLbl.text = "Connected devices: "
        connectedLbl.textColor = UIColor.black
        self.view.addSubview(connectedLbl)
        
        connectedList = UITableView()
        connectedList.frame = CGRect(x: 0, y: peerList.frame.maxY + UIScreen.scale(20), width: self.view.frame.width, height: self.view.frame.height/2-UIScreen.scale(20))
        connectedList.dataSource = self
        connectedList.delegate = self
        connectedList.separatorStyle = .singleLineEtched
        connectedList.register(SingleLineTableViewCell.self, forCellReuseIdentifier: connectedListCellIdentifier)
        connectedList.alwaysBounceVertical = true
        
        communication.delegate = self
        self.view.addSubview(connectedList)
        self.view.addSubview(peerList)
        

        
    
    }
    
    @objc func timerFired() {

        print(TimeManager.shared.now().dateWithMillisecInString())
        AudioServicesPlaySystemSound(1322)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count : Int?
        
        if tableView == self.peerList
        {
            count = peers.count

        }
        if tableView == self.connectedList
        {
            count = connectedPeers.count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : SingleLineTableViewCell!
        
        if tableView == self.peerList
        {
            cell = tableView.dequeueReusableCell(withIdentifier: listCellIdentifier, for: indexPath) as! SingleLineTableViewCell
            let configCell = ConfigurationSingeLineTableViewCell(deviceName: String(describing: peers[indexPath.row].displayName), backColor: Constants.COLOR_LRM_BLACK)
            cell.configure(configCell)
            
        }
        if tableView == self.connectedList
        {
            cell = tableView.dequeueReusableCell(withIdentifier: connectedListCellIdentifier, for: indexPath) as! SingleLineTableViewCell
            let configCell = ConfigurationSingeLineTableViewCell(deviceName: String(describing: connectedPeers[indexPath.row].displayName), backColor: Constants.COLOR_LRM_BLACK)
            cell.configure(configCell)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.scale(60)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.peerList
        {
            let selectedPeer = peers[indexPath.row]
            let browser = communication.browser
            let session = communication.session
            browser?.invitePeer(selectedPeer, to: session, withContext: nil, timeout: 10)
        }
        if tableView == self.connectedList
        {
            do {
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
                Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.timerFired), userInfo: self, repeats: false)
                try  communication.session.send(dateFormatter.string(from: TimeManager.shared.calculateStartTime(offset: 4)).data(using: .utf8)!, toPeers: connectedPeers, with: .reliable)
                
                print(dateFormatter.string(from: date))
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        
       
        
    }
    
    
    func peersChanged(peers: [MCPeerID]) {
        self.peers = peers
        peerList.reloadData()

    }
    
    func invitationReceived(fromPeer: String) {
        
        let alert = UIAlertController(title: "Connecting", message: "\(fromPeer) wants to connect.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.communication.invitationHandler(true, self.communication.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            self.communication.invitationHandler(false,nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func connectedWithPeer(_ peerID: MCPeerID) {
        self.connectedPeers.append(peerID)
        DispatchQueue.main.async {
            self.connectedList.reloadData()

        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

