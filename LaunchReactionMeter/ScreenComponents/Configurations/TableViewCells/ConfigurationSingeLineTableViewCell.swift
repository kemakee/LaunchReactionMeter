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
    var backColor : UIColor!
    
    init(deviceName: String, backColor: UIColor) {
        super.init()
        self.deviceName = deviceName
        self.backColor = backColor
    }
}
