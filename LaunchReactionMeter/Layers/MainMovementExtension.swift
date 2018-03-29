//
//  MainMovementExtension.swift
//  AppCore
//
//  Created by Codevision iMac on 2018. 01. 23..
//  Copyright © 2018. CodeVision. All rights reserved.
//

import UIKit
import Foundation

extension MainViewController {
    @objc func processPanGesture(_ sender: UIPanGestureRecognizer) {
        if getStackSize() > 1 {
            moveContent(sender: sender)
        } else {
            moveMenu(sender: sender)
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

    func moveMenu(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            setShadeVisibility(toHidden: false)
        case .changed:
            let translation = sender.translation(in: sender.view)
            sender.setTranslation(CGPoint.zero, in: sender.view)

            menuLayer.drag(delta: translation.x, completionHandler: nil)
        case .ended:
            let velocity = sender.velocity(in: sender.view).x
            if isFastVelocity(velocity) {
                animateMenu(back: menuLayer.isOpened ? velocity > 0 : velocity < 0)
            } else {
                if isDragOverThreshold() {
                    animateMenu()
                } else {
                    animateMenu(back: true)
                }
            }
        default: ()
        }
    }

    func isFastVelocity(_ velocity: CGFloat) -> Bool {
        return abs(velocity) > Constants.navigationVelocityTrigger
    }

    func isDragOverThreshold() -> Bool {
        if menuLayer.isOpened {
            return menuLayer.frame.maxX < UIScreen.screenWidth * Constants.closeMenuThresholdTrigger
        } else {
            return menuLayer.frame.maxX > UIScreen.screenWidth * Constants.openMenuThresholdTrigger
        }
    }

    func animateMenu(back: Bool = false) {
        if menuLayer.isOpened && back {
            menuLayer.animateIn(completionHandler: nil)
        } else if menuLayer.isOpened && !back {
            menuLayer.animateOut(completionHandler: nil)
        } else if back {
            menuLayer.animateOut(completionHandler: nil)
        } else {
            menuLayer.animateIn(completionHandler: nil)
        }
    }
}
