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

class SegmentedViewController: BaseContentViewController, SegmentedControlDelegate,  UITableViewDataSource, UITableViewDelegate, MultiPeerCommunicationManagerDelegate, MotionManagerDelegate  {


    let scBackViewHeight = UIScreen.scale(50)
    var viewsHeight: CGFloat!
    var items: [String]!
    var viewArray: [UIView] = []
    var LRMSecCon : SegmentedControl!
    var userType : UserType!
    var communication : MultiPeerCommunicationManager!
    var launchBtn : LRMButton!
    var connectedLbl : Label!
    var stopperLbl : Label!
    var shotTime : Date!
    var userResults: [UserResult]!
    var athleteResults: [AthleteResult] = [AthleteResult]()
    let resultDateFormatter = DateFormatter()
    var timerState: TimerState = .go
    
    
    private var peers = [PeersWithConnectedStatus]()
    private var connectedPeers = [MCPeerID]()
    
    var tvListForLaunch: UITableView!
    var tvListForResults: UITableView!
    


    let cellIdentifierForLaunch = "cellIdentifierForLaunch"
    let cellIdentifierForResults = "cellIdentifierForResults"

    var counter = 0.0
    var timer = Timer()
    var isPlaying = false


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
        
        viewsHeight = UIScreen.screenHeight - UIScreen.statusBarHeight - scBackViewHeight

        LoggedInConfigurator.configureLoggedInSegmentedController(viewController: self)

        let forLaunchView = UIView(frame: CGRect(x: 0, y: contentHeight, width: self.view.frame.size.width, height: viewsHeight))
        self.svContent.addSubview(forLaunchView)
        viewArray.append(forLaunchView)

        if userType == .coach
        {
            tvListForLaunch = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - (MainViewController.shared.headerLayer?.height)!), style: .plain)
            tvListForLaunch.dataSource = self
            tvListForLaunch.delegate = self
            tvListForLaunch.separatorStyle = .none
            tvListForLaunch.register(SingleLineTableViewCell.self, forCellReuseIdentifier: cellIdentifierForLaunch)
            tvListForLaunch.backgroundColor = Constants.COLOR_LRM_BLACK
            forLaunchView.addSubview(tvListForLaunch)

            let configStopperbl = ConfigurationLabel(size: CGSize(width: UIScreen.screenWidth*0.6, height: UIScreen.scale(50)), text: "00:00:00")
            configStopperbl.font = UIFont.systemFont(ofSize: UIFont.systemFontSize+30)
            stopperLbl = Label(configuration: configStopperbl)
            stopperLbl.textAlignment = .center
            stopperLbl.textColor = Constants.COLOR_LRM_WHITE
            forLaunchView.addSubview(stopperLbl)


            let configLaunchBtn = ConfigurationLRMButton(y: 0, text: "GO!", color: .white, size: .normal)
            launchBtn = LRMButton(configuration: configLaunchBtn)
            forLaunchView.addSubview(launchBtn)
            launchBtn.addTarget(self, action: #selector(goPressed), for: .touchUpInside)
        }
        resultDateFormatter.dateFormat = "y.MM.dd HH:mm:ss"
        tvListForResults = UITableView(frame: CGRect(x: 0, y: contentHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - (MainViewController.shared.headerLayer?.height)!-contentHeight), style: .plain)
        tvListForResults.dataSource = self
        tvListForResults.delegate = self
        tvListForResults.separatorStyle = .none
        tvListForResults.register(SingleLineWithTwoDataTableCell.self, forCellReuseIdentifier: cellIdentifierForResults)
        tvListForResults.backgroundColor = Constants.COLOR_LRM_BLACK
        self.svContent.addSubview(tvListForResults)
        tvListForResults.isHidden = true


        if userType == .athlete
        {
            let configConnectedLbl = ConfigurationLabel(size: CGSize(width: UIScreen.screenWidth*0.6, height: UIScreen.scale(50)), text: "Not Connected")
            connectedLbl = Label(configuration: configConnectedLbl)
            connectedLbl.textAlignment = .center
            connectedLbl.backgroundColor = Constants.COLOR_LRM_RED_50
            forLaunchView.addSubview(connectedLbl)

            DatabaseManager.shared.readResults { (results) in
                self.userResults = results
                self.tvListForResults.reloadData()
            }
            
        }
        
        
        
        
        items = ["Launch","Results"]
        
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
             make.top.equalTo(UIScreen.screenHeight*0.87)
            make.left.equalTo((UIScreen.screenWidth/2-LRMSecCon.width/2))
            make.width.equalTo(LRMSecCon.width)
            make.height.equalTo(LRMSecCon.height)
        }
        
        if userType == .athlete
        {
            connectedLbl.snp.makeConstraints { (make) in
                make.top.equalTo(UIScreen.screenHeight*0.60)
                make.left.equalTo((UIScreen.screenWidth/2-connectedLbl.width/2))
                make.width.equalTo(connectedLbl.width)
                make.height.equalTo(connectedLbl.height)
            }
        }
        if userType == .coach
        {
            launchBtn.snp.makeConstraints { (make) in
                make.top.equalTo(UIScreen.screenHeight*0.70)
                make.left.equalTo((UIScreen.screenWidth/2-launchBtn.width/2))
                make.width.equalTo(launchBtn.width)
                make.height.equalTo(launchBtn.height)
            }

            stopperLbl.snp.makeConstraints { (make) in
                make.top.equalTo(UIScreen.screenHeight*0.60)
                make.left.equalTo((UIScreen.screenWidth/2-stopperLbl.width/2))
                make.width.equalTo(stopperLbl.width)
                make.height.equalTo(stopperLbl.height)
            }
        }
        
        super.updateViewConstraints()
        
        }

    func SegmentedControlWichPressed(_ segmentedControl: SegmentedControl, whichPressed: Int) {
        viewArray.forEach({ $0.isHidden = !$0.isHidden })
        if(whichPressed == 1)
        {
            DatabaseManager.shared.readResults { (results) in
                self.userResults = results
                self.tvListForResults.reloadData()
            }
        }
    }
    
  
    
    func peersChanged(peers: [MCPeerID]) {
        
        var tmpPeers = [MCPeerID]()
        for peer in self.peers
        {
            tmpPeers.append(peer.peer)
        }
        for peer in peers
        {
           
            if !tmpPeers.contains(peer)
            {
                self.peers.append(PeersWithConnectedStatus(peer: peer))
            }
        }
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
            if peer.peer == peerID && userType == .coach
            {
                let indexPath = IndexPath(row: index, section: 0)
                peers[index].isConnected = true
                DispatchQueue.main.async {
                self.tvListForLaunch.reloadData()
                }
                
            }
            index += 1
        }
        if connectedPeers.count > 0
        {
            DispatchQueue.main.async {
                if self.userType == UserType.coach
                {
                    let configLaunchBtn = ConfigurationLRMButton(y: self.launchBtn.y, text: "GO!", color: .orange, size: .normal)
                    self.launchBtn.reconfigure(configLaunchBtn)
                }
                if self.userType == UserType.athlete
                {
                    self.connectedLbl.backgroundColor = Constants.COLOR_LRM_GREEN_50
                    self.connectedLbl.text = "Connected"
                }
                
            }
          
        
        }
        
    }
    
    func lostPeer(_ peerID: MCPeerID) {
       if let index = connectedPeers.index(of: peerID)
       {
        connectedPeers.remove(at: index)
        }
        
        var tmpPeers = [MCPeerID]()
        for peer in self.peers
        {
            tmpPeers.append(peer.peer)
        }
        
        if let index = tmpPeers.index(of: peerID)
        {
            peers.remove(at: index)
        }
        if connectedPeers.count == 0
        {
            DispatchQueue.main.async {
                
                if self.userType == UserType.coach && self.timerState != .stop
                {
                        let configLaunchBtn = ConfigurationLRMButton(y: self.launchBtn.y, text: "GO!", color: .white, size: .normal)
                        self.launchBtn.reconfigure(configLaunchBtn)
   
                }
             
                
            }
        }
        self.tvListForLaunch.reloadData()
  
        
    }

    func startHappend(startdate: Date) {

        DispatchQueue.main.async {
            let offset = TimeManager.shared.calculateOffsetFromNetActualTime(date: startdate)
            Timer.scheduledTimer(timeInterval: offset, target: self, selector: #selector(self.timerFired), userInfo: self, repeats: false)
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tvListForLaunch {
            return peers.count
        }
        else if tableView == tvListForResults {
            if userType == .athlete{
                return userResults != nil ? userResults.count : 0
            }else {
                return athleteResults.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tvListForLaunch){
            var cell : SingleLineTableViewCell!

            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierForLaunch, for: indexPath) as! SingleLineTableViewCell

            let configCell = ConfigurationSingeLineTableViewCell(deviceName:String(describing: peers[indexPath.row].peer.displayName), backColor : peers[indexPath.row].isConnected ? Constants.COLOR_LRM_GREEN : Constants.COLOR_LRM_ORANGE)
            cell.configure(configCell)

            return cell
        }
        else if tableView == tvListForResults {
            let cell : SingleLineWithTwoDataTableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierForResults, for: indexPath) as! SingleLineWithTwoDataTableCell
            let configCell: ConfigurationSingleLineWithTwoLabelCell
            if userType == .athlete{

                let userResult = userResults[indexPath.row]
                configCell = ConfigurationSingleLineWithTwoLabelCell(dataText: resultDateFormatter.string(from: userResult.date!) , resultText: String(userResult.result)+" sec")

            }
            else {
                let athleteResult = athleteResults[indexPath.row]
                configCell = ConfigurationSingleLineWithTwoLabelCell(dataText: athleteResult.name , resultText: String(athleteResult.result))

            }
            cell.configure(configCell)
            return cell
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tvListForLaunch && !peers[indexPath.row].isConnected
        {
            let selectedPeer = peers[indexPath.row].peer
            let browser = communication.browser
            let session = communication.session
            browser?.invitePeer(selectedPeer!, to: session, withContext: nil, timeout: 10)
        }

        
    }
    
    @objc func goPressed()
    {
        guard self.connectedPeers.count != 0  || timerState == .stop || timerState == .reset else {
            return
        }

        if(timerState == .go)
        {
            do {
                athleteResults.removeAll()
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
                let randomOffset = Double.random(min: 0.7, max: 1.5)
                Timer.scheduledTimer(timeInterval: randomOffset, target: self, selector: #selector(self.timerFired), userInfo: self, repeats: false)
                try  communication.session.send(dateFormatter.string(from: TimeManager.shared.calculateStartTime(offset: randomOffset)).data(using: .utf8)!, toPeers: connectedPeers, with: .reliable)

                print(dateFormatter.string(from: date))
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        else if(timerState == .stop)
        {
            stopTimer()
        }
        else if(timerState == .reset)
        {
            resetTimer()
        }

        
    }
    @objc func timerFired() {

        shotTime = Date()
        if userType == .athlete
        {
            MotionManager.shared.start()
            MotionManager.shared.delegate = self
            AudioServicesPlaySystemSound(1322)
        }
        else{
            startTimer()
        }
        
        print(TimeManager.shared.now().dateWithMillisecInString())
        blinkScreen()
        
        
    }

    func gyroTriggered() {

        let difference = Date().timeIntervalSince(shotTime)
        let result = Double(round(difference*1000)/1000)
        showResult(result)
        DatabaseManager.shared.addResult(result: result)
        try? communication.session.send(String(result).data(using: .utf8)!, toPeers: [connectedPeers.first!], with: .reliable)
    }

    func resultRecieved(_ peerID: MCPeerID, _ timeInterval: Double) {
        let result = AthleteResult()
        result.name = peerID.displayName
        result.result = timeInterval
        athleteResults.append(result)
        DispatchQueue.main.async {
            self.tvListForResults.reloadData()
        }

    }

    func showResult(_ timeInterval : Double)
    {
        let alert = UIAlertController(title: "Result", message: "\(timeInterval) is your reaction time.", preferredStyle: UIAlertControllerStyle.alert)

        let acceptAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.communication.invitationHandler(true, self.communication.session)
        }


        alert.addAction(acceptAction)

        self.present(alert, animated: true, completion: nil)
    }
    func blinkScreen(){
        let wnd = UIApplication.shared.keyWindow;
        let v = UIView(frame: CGRect(x:0, y:0, width: wnd!.frame.size.width, height:wnd!.frame.size.height))
        wnd!.addSubview(v);
        v.backgroundColor = UIColor.white
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1.0)
        v.alpha = 0.0;
        UIView.commitAnimations()
    }

    func startTimer() {
        timerState = .stop
        launchBtn.setTitle("STOP", for: .normal)

        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        timerState = .reset
        launchBtn.setTitle("RESET", for: .normal)
        timer.invalidate()
    }

    func resetTimer()
    {
        timerState = .go
        if connectedPeers.count == 0
        {
             let configLaunchBtn = ConfigurationLRMButton(y: self.launchBtn.y, text: "GO!", color: .white, size: .normal)
            launchBtn.reconfigure(configLaunchBtn)
        }
        else{
            launchBtn.setTitle("GO!", for: .normal)
        }
        stopperLbl.text = "00:00:00"
        counter = 0
    }
    
    @objc func updateTimer() {
        counter = counter + 0.01
        let minute = Int(counter/60)
        stopperLbl.text = String(minute) + ":" + String(format: "%.2f", counter - Double(minute)*60)
    }

}

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}
