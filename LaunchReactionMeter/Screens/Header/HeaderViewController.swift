//
//  HeaderViewController.swift
//  CodeVision
//
//  Created by CodeVision on 14/05/17.
//  Copyright (c) 2017 CodeVision. All rights reserved.
//

import UIKit

class HeaderViewController: BaseHeaderViewController {

    var btnNavigation: HamburgerButton!

    override func initLayout() {
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.scale(44))
        view.backgroundColor = .black

        //navigation button
        let frame = CGRect(x: UIScreen.scale(16), y: UIScreen.scale(4), width: UIScreen.scale(36), height: UIScreen.scale(36))
        btnNavigation = HamburgerButton(frame: frame)
        btnNavigation.color = .white
        btnNavigation.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        btnNavigation.centerY = view.centerY
        btnNavigation.x = UIScreen.scale(20)

        setNavigationStateTo(.menu)
        view.addSubview(btnNavigation!)

        let btnTouch = UIButton(frame: CGRect(x: 0, y: 0, width: btnNavigation!.x + btnNavigation!.width + btnNavigation!.y, height: view.height))
        view.addSubview(btnTouch)
        btnTouch.addTarget(self, action: #selector(HeaderViewController.btnNavigationPressed), for: .touchUpInside)
    }

    @objc func btnNavigationPressed() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        if (hasViewStackElement()) {
            navigateBack()
        } else {
            if let menu = MainViewController.shared.menuLayer {
                if menu.isOpened {
                    menu.animateOut(completionHandler: nil)
                } else {
                    menu.animateIn(completionHandler: nil)
                }
            }
        }
    }

    private func hasViewStackElement() -> Bool {
        return MainViewController.shared.getStackSize() > 1
    }

    private func navigateBack() {
        btnNavigation.isUserInteractionEnabled = false
        MainViewController.shared.navigateBack(withAnimation: true)
        self.btnNavigation.isUserInteractionEnabled = true
    }

    override func setNavigationStateTo(_ state: HeaderNavigationState) {
        self.navigationState = state

        switch(state) {
        case .none:
            btnNavigation!.isHidden = true
        case .menu:
            btnNavigation!.isHidden = false
            btnNavigation!.showMenu(true)
        case .back:
            btnNavigation!.isHidden = false
            btnNavigation!.showMenu(false)
        }
    }

    override func refreshContent() {
        self.setNavigationStateTo(hasViewStackElement() ? .back: .menu)
    }

}
