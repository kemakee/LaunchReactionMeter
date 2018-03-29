//
//  FullScreenWaitingViewController.swift
//  CodeVision
//
//  Created by CodeVision on 14/05/17.
//  Copyright (c) 2017 CodeVision. All rights reserved.
//

import UIKit
import Foundation

class FullScreenWaitingViewController: BaseWaitingViewController {
    var aivLoader: UIActivityIndicatorView!

    override func initLayout() {
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .black

        aivLoader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aivLoader.backgroundColor = .clear
        aivLoader.color = .white
        aivLoader.origin = CGPoint(x: (view.width - aivLoader.width) / 2, y: view.height * 2 / 3 - aivLoader.height / 2)
        aivLoader.startAnimating()
        view.addSubview(aivLoader)
    }

}
