//
//  SegmentedViewController.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Kronos
import AudioToolbox

class SegmentedViewController: BaseContentViewController, SegmentedControlDelegate,  UITableViewDataSource, UITableViewDelegate, MultiPeerCommunicationManagerDelegate  {

 
    

    let scBackViewHeight = UIScreen.scale(50)
    var viewsHeight: CGFloat!
    var listView: UIView!
    var items: [String]!
    var viewArray: [UIView] = []
    var LRMSecCon : SegmentedControl!
    var userType : UserType!
    var communication : MultiPeerCommunicationManager!
    var launchBtn : LRMButton!
    
    private var peers = [MCPeerID]()
    private var connectedPeers = [MCPeerID]()
    
    var tvListForLaunch: UITableView!
    var tvListForResults: UITableView!
    


    let cellIdentifier = "cellIdentifier"
    let cellIdentifier1 = "cellIdentifier1"



    var loggedInInteractor: LoggedInInteractorProtocol {
        
        return interactor as! LoggedInInteractorProtocol
    }
    
    init(_ userType : UserType)
    {
        self.userType = userType
        communication = MultiPeerCommunicationManager(userType: userType)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func initLayout() {
        super.initLayout()
        self.svContent.isScrollEnabled = false
        self.svContent.backgroundColor = Constants.COLOR_LRM_BLACK
        
        viewsHeight = self.svContent.height-scBackViewHeight

        LoggedInConfigurator.configureLoggedInSegmentedController(viewController: self)
        
        listView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenHeight, height: viewsHeight))
        self.svContent.addSubview(listView)
        listView.isUserInteractionEnabled = true
        
        
        tvListForLaunch = UITableView(frame: CGRect(x: 0, y: contentHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - (MainViewController.shared.headerLayer?.height)!-contentHeight), style: .plain)
        tvListForLaunch.dataSource = self
        tvListForLaunch.delegate = self
        tvListForLaunch.separatorStyle = .none
        tvListForLaunch.register(SingleLineTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tvListForLaunch.backgroundColor = Constants.COLOR_LRM_BLACK
        self.svContent.addSubview(tvListForLaunch)
        
        //MARK: TODO
        tvListForResults = UITableView(frame: CGRect(x: 0, y: contentHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - (MainViewController.shared.headerLayer?.height)!-contentHeight), style: .plain)
        tvListForResults.dataSource = self
        tvListForResults.delegate = self
        tvListForResults.separatorStyle = .none
        tvListForResults.register(SingleLineTableViewCell.self, forCellReuseIdentifier: cellIdentifier1)
        tvListForResults.backgroundColor = Constants.COLOR_LRM_BLACK
        
        let configLaunchBtn = ConfigurationLRMButton(y: 0, text: "GO!", color: .white, size: .normal)
        launchBtn = LRMButton(configuration: configLaunchBtn)
        self.svContent.addSubview(launchBtn)
        
        
        
        items = ["Launch","Results"]
        viewArray.append(tvListForLaunch)
        viewArray.append(tvListForResults)
        
        let configurationSC = ConfigurationSegmentedControl(y: viewsHeight, titles: items)
        LRMSecCon = SegmentedControl(configuration: configurationSC)
        LRMSecCon.delegate = self
        
        communication.delegate = self
        
        self.svContent.addSubview(LRMSecCon)

        self.view.setNeedsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        
        LRMSecCon.snp.makeConstraints { (make) in
             make.bottom.equalTo(UIScreen.screenHeight*0.885)
            make.left.equalTo((UIScreen.screenWidth/2-LRMSecCon.width/2))
            make.width.equalTo(LRMSecCon.width)
            make.height.equalTo(LRMSecCon.height)
        }
        
        launchBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(UIScreen.screenHeight*0.70)
            make.left.equalTo((UIScreen.screenWidth/2-launchBtn.width/2))
            make.width.equalTo(launchBtn.width)
            make.height.equalTo(launchBtn.height)
        }
        
        super.updateViewConstraints()
        
        }

    func SegmentedControlWichPressed(_ segmentedControl: SegmentedControl, whichPressed: Int) {
          viewArray.forEach({ $0.isHidden = !$0.isHidden })
    }
    
  
    
    func peersChanged(peers: [MCPeerID]) {
        self.peers = peers
        tvListForLaunch.reloadData()
        
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
        var index : Int = 0
        for peer in self.peers
        {
            if peer == peerID
            {
                let indexPath = IndexPath(row: index, section: 0)
                DispatchQueue.main.async {
                    let cell =  self.tvListForLaunch.cellForRow(at: indexPath) as! SingleLineTableViewCell
                    let configCell = ConfigurationSingeLineTableViewCell(deviceName: cell.nameLbl.text!, backColor : UIColor.green)
                    cell.reconfigure(configCell)
                }
                
            }
            index += 1
        }
        if connectedPeers.count > 0
        {
            DispatchQueue.main.async {
                let configLaunchBtn = ConfigurationLRMButton(y: self.launchBtn.y, text: "GO!", color: .orange, size: .normal)
                self.launchBtn.reconfigure(configLaunchBtn)
                
            }
        }
        
    }
    
    func lostPeer(_ peerID: MCPeerID) {
       if let index = connectedPeers.index(of: peerID)
       {
        connectedPeers.remove(at: index)
        }
        if connectedPeers.count == 0
        {
            DispatchQueue.main.async {
                let configLaunchBtn = ConfigurationLRMButton(y: self.launchBtn.y, text: "GO!", color: .white, size: .normal)
                self.launchBtn.reconfigure(configLaunchBtn)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return peers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : SingleLineTableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SingleLineTableViewCell
        let configCell = ConfigurationSingeLineTableViewCell(deviceName:String(describing: peers[indexPath.row].displayName), backColor : Constants.COLOR_LRM_BLACK)
        cell.configure(configCell)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tvListForLaunch
        {
            let selectedPeer = peers[indexPath.row]
            let browser = communication.browser
            let session = communication.session
            browser?.invitePeer(selectedPeer, to: session, withContext: nil, timeout: 10)
        }
        tableView.cellForRow(at: indexPath)
        //        if tableView == self.connectedList
//        {
//            do {
//                let date = Date()
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
//                Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.timerFired), userInfo: self, repeats: false)
//                try  communication.session.send(dateFormatter.string(from: TimeManager.shared.calculateStartTime(offset: 4)).data(using: .utf8)!, toPeers: connectedPeers, with: .reliable)
//
//                print(dateFormatter.string(from: date))
//            }
//            catch let error {
//                NSLog("%@", "Error for sending: \(error)")
//            }
//        }
        
        
        
    }

}
