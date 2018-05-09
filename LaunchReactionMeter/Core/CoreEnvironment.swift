//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//
import Foundation
import UIKit

private let KEY_DEVICE_ID: String = "key_device_id"

class CoreEnvironment: NSObject {

    static var shared = CoreEnvironment()

    var osVersion: String!
    var deviceModel: String!
    var deviceType: String!
    var width: CGFloat = 0
    var height: CGFloat = 0

    var applicationVersion: String!
    var buildNumber: String!
    var userType : UserType!

    var currentInteractor: BaseInteractorProtocol!

    override private init() {
        super.init()
        setDeviceInfo()
        setAppInfo()
    }

    func setDeviceInfo() {
        let currentDevice: UIDevice = UIDevice.current
        osVersion = currentDevice.systemVersion
        deviceModel = currentDevice.model
        deviceType = currentDevice.model.hasPrefix("iPad") ? "tablet": "mobile"

        if let screenSize = UIScreen.main.currentMode?.size {
            width = screenSize.width
            height = screenSize.height
        }
    }

    func setAppInfo() {
        applicationVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        buildNumber = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    class func readPlistContent(_ fileUrl: String) -> NSDictionary {
        if !FileManager.default.fileExists(atPath: fileUrl) {
            NSException.raise(NSExceptionName(rawValue: "Lookup error"), format: "Couldn't load info file: %@", arguments: getVaList([fileUrl]))
        }

        return NSDictionary(contentsOfFile: fileUrl)!
    }


    func getiOSVersion() -> Float {
        return (UIDevice.current.systemVersion as NSString).floatValue
    }
}
