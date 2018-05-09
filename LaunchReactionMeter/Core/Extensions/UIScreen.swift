//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import Foundation

extension UIScreen {

    class func fullScreenSize() -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }

    class var screenHeight: CGFloat {
        let uiScreenBoundsSize = UIScreen.main.bounds.size
        let isPortrait = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
        let iOSversion = CoreEnvironment.shared.getiOSVersion()
        return iOSversion < 8.0 ? (isPortrait ? uiScreenBoundsSize.height : uiScreenBoundsSize.width) : uiScreenBoundsSize.height
    }

    class var screenWidth: CGFloat {
        let uiScreenBoundsSize = UIScreen.main.bounds.size
        let isPortrait = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
        let iOSversion = CoreEnvironment.shared.getiOSVersion()
        return iOSversion < 8.0 ? (isPortrait ? uiScreenBoundsSize.width : uiScreenBoundsSize.height) : uiScreenBoundsSize.width
    }

    class var statusBarHeight: CGFloat {
        let statusbarFrame = UIApplication.shared.statusBarFrame
        return min(statusbarFrame.height, statusbarFrame.width)
    }

    class var isPortait: Bool {
        return UIScreen.screenWidth < UIScreen.screenHeight
    }

    class func scale(_ x: CGFloat) -> CGFloat {
        return x == 0.0 ? 0.0 : (x / 320.0 * UIScreen.screenWidth)
    }

}
