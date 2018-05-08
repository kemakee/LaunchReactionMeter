//
//  MotionManager.swift
//  LaunchReactionMeter
//
//  Created by Adam Horvath on 2018. 05. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import CoreMotion

protocol MotionManagerDelegate : NSObjectProtocol{
    func gyroTriggered()
}

class MotionManager: NSObject {

    let motionManager = CMMotionManager()

    static let shared = MotionManager()
    weak var delegate : MotionManagerDelegate?


    private override init() {

        super.init()
    }

    func start()
    {


        if motionManager.isGyroAvailable
        {
            motionManager.startGyroUpdates(to: OperationQueue.current!) { (deviceGyro, error) in
                guard error == nil else
                {
                    return
                }
                self.handleDeviceGyroUpdate(deviceGyro: deviceGyro!)
            }
        }
    }

    func stop()
    {
        motionManager.stopGyroUpdates()
    }


    func handleDeviceGyroUpdate(deviceGyro : CMGyroData)
    {
        let gyro = deviceGyro.rotationRate
        self.checkIfMotionTriggered(rotation: gyro)
    }

    func checkIfMotionTriggered(rotation: CMRotationRate)
    {
        let xabs = abs(rotation.x)
        let yabs = abs(rotation.y)
        let zabs = abs(rotation.z)

        if(max(xabs, yabs, zabs) > 2.0)
        {
            print("elindult")
            self.stop()
            delegate?.gyroTriggered()

        }
    }
}
