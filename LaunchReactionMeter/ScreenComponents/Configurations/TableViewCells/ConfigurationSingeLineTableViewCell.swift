//
//  SingeLineTableViewCell.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 03. 07..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class ConfigurationSingeLineTableViewCell: ConfigurationComponent {
    var deviceName : String!
    var connectedColor : UIColor!
    var isConnected : Bool!
    
    init(deviceName: String, backColor: UIColor, isConnected : Bool = false) {
        super.init()
        self.deviceName = deviceName
        self.connectedColor = backColor
        self.isConnected = isConnected
    }
}
