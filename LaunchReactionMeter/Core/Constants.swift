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
    
    
    
    static let dateFormat = "yyyy-MM-dd"
    static let dateAndTimeFormat = "yyyy-MM-dd hh:ss"
    static let dateAndTimeFormatForXaxis = "MM.dd. hh:ss"
    
    static let COLOR_LRM_ORANGE = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0/255.0, alpha: 1.0)// UIColor( red: 117/255, green: 174/255, blue: 242/255, alpha: 1.0)
    static let COLOR_LRM_BLACK = UIColor.black// UIColor(red: 51/255, green: 52/255, blue: 60/255, alpha: 1.0)
    static let COLOR_LRM_BLACK_CELL_BG = UIColor(red: 67/255, green: 68/255, blue: 79/255, alpha: 1.0)
    static let COLOR_LRM_BLACK_CALENDAR = UIColor(red: 97/255, green: 97/255, blue: 103/255, alpha: 1.0)
    static let COLOR_LRM_BLACK_ANIMATION = UIColor(red: 51/255, green: 52/255, blue: 60/255, alpha: 0.7)
    static let COLOR_LRM_RED = UIColor(red: 253/255, green: 0/255, blue: 32/255, alpha: 1.0)
    static let COLOR_LRM_TEXT_GRAY_DARKER = UIColor(red: 45/255, green: 43/255, blue: 48/255, alpha: 1.0)
    static let COLOR_LRM_TEXT_GRAY_LIGHTER = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    static let COLOR_LRM_TEXT_GRAY_TUTORIAL = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.5)
    static let COLOR_LRM_WHITE = UIColor.white
    static let COLOR_LRM_GRAY = UIColor(red: 120/255, green: 118/255, blue: 131/255, alpha: 1.0)
    static let COLOR_LRM_WHITE_40 = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
    static let COLOR_LRM_GREEN = UIColor(red: 129/255, green: 217/255, blue: 31/255, alpha: 1.0)
    static let COLOR_LRM_GREEN_50_DRINK = UIColor(red: 109/255, green: 138/255, blue: 7/255, alpha: 0.78)
    static let COLOR_LRM_GREEN_50 = UIColor(red: 129/255, green: 218/255, blue: 171/255, alpha: 0.78)
    static let COLOR_LRM_RED_50 = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.78)
    static let COLOR_LRM_FACEBOOK_BLUE = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)

    
    static let LRM_TYPO_10 = UIFont.systemFont(ofSize: UIScreen.scale(10))
    static let LRM_TYPO_12 = UIFont.systemFont(ofSize: UIScreen.scale(12))
    static let LRM_TYPO_12B = UIFont.boldSystemFont(ofSize: UIScreen.scale(12))
    static let LRM_TYPO_13 = UIFont.systemFont(ofSize: UIScreen.scale(13))
    static let LRM_TYPO_14 = UIFont.systemFont(ofSize: UIScreen.scale(14))
    static let LRM_TYPO_14B = UIFont.boldSystemFont(ofSize: UIScreen.scale(14))
    static let LRM_TYPO_16 = UIFont.systemFont(ofSize: UIScreen.scale(16))
    static let LRM_TYPO_16B = UIFont.boldSystemFont(ofSize: UIScreen.scale(16))
    static let LRM_TYPO_18 = UIFont.systemFont(ofSize: UIScreen.scale(18))
    static let LRM_TYPO_18B = UIFont.boldSystemFont(ofSize: UIScreen.scale(18))
    static let LRM_TYPO_20 = UIFont.systemFont(ofSize: UIScreen.scale(20))
    static let LRM_TYPO_20B = UIFont.boldSystemFont(ofSize: UIScreen.scale(20))
    static let LRM_TYPO_24 = UIFont.systemFont(ofSize: UIScreen.scale(24))
    static let LRM_TYPO_24B = UIFont.boldSystemFont(ofSize: UIScreen.scale(24))
}

