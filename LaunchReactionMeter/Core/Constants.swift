//
//  Constants.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 02. 26..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class Constants {
    
    static let testMode = false
    static var isPreloadSync = false
    static let DB_Query_Writer = false
    
    static let coreAnimationDuration: TimeInterval = 0.6
    static let navigationVelocityTrigger: CGFloat = 1500
    static let navigationThresholdTrigger: CGFloat = 0.5
    static let openMenuThresholdTrigger: CGFloat = 0.3
    static let closeMenuThresholdTrigger: CGFloat = 0.5
    
    static let shadeLayerMaxAlpha: CGFloat = 0.5
    
    static let FILE_LOG = "log.txt"
    
    static let headerText = "AppCore"
    
    static let dateFormat = "yyyy-MM-dd"
    static let dateAndTimeFormat = "yyyy-MM-dd hh:ss"
    static let dateAndTimeFormatForXaxis = "MM.dd. hh:ss"
}

