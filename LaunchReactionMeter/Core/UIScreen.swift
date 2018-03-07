//
//  UIScreen.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 03. 07..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

extension UIScreen
{
    
    class var screenWidth: CGFloat {
        let uiScreenBoundsSize = UIScreen.main.bounds.size
        let isPortrait = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
        let iOSversion = (UIDevice.current.systemVersion as NSString).floatValue
        return iOSversion < 8.0 ? (isPortrait ? uiScreenBoundsSize.width : uiScreenBoundsSize.height) : uiScreenBoundsSize.width
    }
    class func scale(_ x: CGFloat) -> CGFloat {
        return x == 0.0 ? 0.0 : (x / 320.0 * UIScreen.screenWidth)
    }
}
