//
//  SnackbarViewController.swift
//  AppCore
//
//  Created by CodeVision on 14/05/17.
//  Copyright © 2017 Kft. All rights reserved.
//

import UIKit
import Foundation

class SnackbarViewController: BaseToastViewController {
    var snackbarText: String
    var message: Label!

    init(text: String) {
        snackbarText = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initLayout() {
        self.view.autoresizingMask = UIViewAutoresizing()

        self.view.backgroundColor = UIColor.black
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let padding = UIScreen.scale(20)
        let lblMessageConfig = ConfigurationLabel(size: CGSize(width: UIScreen.screenWidth - 2 * padding, height: 100), text: snackbarText)
        lblMessageConfig.textColor = .white

        message = Label(configuration: lblMessageConfig)
        message.textAlignment = .center

        self.view.height = message.y + message.height + UIScreen.scale(15)

        self.view.addSubview(message)
    }
}
