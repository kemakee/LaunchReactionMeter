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
    
    init(deviceName: String) {
        super.init()
        self.deviceName = deviceName
    }
}
