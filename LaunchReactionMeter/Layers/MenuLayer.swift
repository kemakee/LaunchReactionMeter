//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class MenuLayer: UIView, MovementProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestures()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isOpened: Bool = false

    private func addGestures() {
        let menuPanGesture = UIPanGestureRecognizer(target: self, action: #selector(forwardPanGesture(_ :)))
        self.addGestureRecognizer(menuPanGesture)
    }

    @objc private func forwardPanGesture(_ sender: UIPanGestureRecognizer) {
        MainViewController.shared.processPanGesture(sender)
    }

    func animateIn(completionHandler: (() -> Void)?) {
        MainViewController.shared.setShadeVisibility(toHidden: false)
        UIView.animate(withDuration: Constants.coreAnimationDuration, animations: {
            self.x = 0
            MainViewController.shared.shadeLayer.alpha = Constants.shadeLayerMaxAlpha
        }, completion: { _ in
            self.isOpened = true
            completionHandler?()
        })
    }

    func animateOut(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: Constants.coreAnimationDuration, animations: {
            self.x = -self.width
            MainViewController.shared.shadeLayer.alpha = 0
        }, completion: { _ in
            MainViewController.shared.setShadeVisibility(toHidden: true)
            self.isOpened = false
            completionHandler?()
        })
    }

    func drag(delta: CGFloat, completionHandler: (() -> Void)?) {
        self.x = min(0, self.x + delta)
        setShadeLayerAlpha()
        completionHandler?()
    }

    private func setShadeLayerAlpha() {
        MainViewController.shared.setShadeVisibility(toHidden: false)
        let onScreenRatio: CGFloat = (self.x + self.width) / self.width
        let newAlpha = onScreenRatio * Constants.shadeLayerMaxAlpha
        MainViewController.shared.shadeLayer.alpha = newAlpha
    }

}
