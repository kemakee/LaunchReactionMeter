//
//  MenuViewController.swift
//  Okosradiator
//
//  Created by Provender Roxána on 2018. 02. 23..
//  Copyright © 2018. CodeVision. All rights reserved.
//

import UIKit

class MenuViewController: BaseMenuViewController {

    var menuInteractor: MenuInteractorProtocol {

        return interactor as! MenuInteractorProtocol
    }

    override func initLayout() {
        super.initLayout()

        

    }

    @objc func doNavigateToDeviceList() {
    }

    @objc func doNavigateToRoom() {

    }

    @objc func navigateToSCH() {
    
    }

}
