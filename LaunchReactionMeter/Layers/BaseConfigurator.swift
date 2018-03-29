//
//  BaseConfigurator.swift
//
//  Created by CodeVision on 2017. 06. 20..
//  Copyright © 2017. Codevision. All rights reserved.
//

import Foundation

class BaseConfigurator: NSObject {

    class func getInteractor(byProtocol proto: Protocol) -> BaseInteractorProtocol? {
        if let currentInteractor = CoreEnvironment.shared.currentInteractor, (currentInteractor as! BaseInteractor).conforms(to: proto) {
            return currentInteractor
        } else {
            for iterVC in MainViewController.shared.savedContents {
                if let interactor = iterVC.interactor, (interactor as! BaseInteractor).conforms(to: proto) {
                    return interactor
                }
            }

            return nil
        }
    }
}
