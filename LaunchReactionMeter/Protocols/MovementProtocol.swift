//
//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//
import UIKit
import Foundation

@objc protocol MovementProtocol {

    func drag(delta: CGFloat, completionHandler: (() -> Void)?)

    func animateIn(completionHandler: (() -> Void)?)

    func animateOut(completionHandler: (() -> Void)?)

    @objc optional func beforeSlide()

    @objc optional func afterSlide()
}
