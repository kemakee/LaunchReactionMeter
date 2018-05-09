//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
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
