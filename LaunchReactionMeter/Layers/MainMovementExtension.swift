//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import Foundation

extension MainViewController {
    @objc func processPanGesture(_ sender: UIPanGestureRecognizer) {
        if getStackSize() > 1 {
            moveContent(sender: sender)
        } 
    }

    func moveContent(sender: UIPanGestureRecognizer) {
        if let delegate = sender.delegate as? MovementProtocol {
            switch sender.state {
            case .began:
                delegate.beforeSlide?()
            case .changed:
                let translation = sender.translation(in: sender.view)
                sender.setTranslation(CGPoint.zero, in: sender.view)

                delegate.drag(delta: translation.x, completionHandler: nil)
            case .ended:
                if sender.velocity(in: sender.view).x > Constants.navigationVelocityTrigger {
                    navigateBack()
                } else if sender.view!.x > UIScreen.screenWidth * Constants.navigationThresholdTrigger {
                    navigateBack()
                } else {
                    delegate.animateIn(completionHandler: nil)
                }
                delegate.afterSlide?()
            default: ()
            }
        }
    }

  
}
