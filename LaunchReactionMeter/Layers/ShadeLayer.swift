//
//  ShadeLayer.swift
//  AppCore
//
//  Created by Codevision iMac on 2018. 01. 15..
//  Copyright © 2018. CodeVision. All rights reserved.
//

import UIKit

class ShadeLayer: UIView, UIGestureRecognizerDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        addGestures()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addGestures() {
        let menuClosingTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        self.addGestureRecognizer(menuClosingTap)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(forwardPanGesture(_ :)))
        self.addGestureRecognizer(panGesture)
    }

    @objc private func closeMenu() {
        MainViewController.shared.menuLayer.animateOut(completionHandler: nil)
    }

    @objc func forwardPanGesture(_ sender: UIPanGestureRecognizer) {
        MainViewController.shared.processPanGesture(sender)
    }

}
