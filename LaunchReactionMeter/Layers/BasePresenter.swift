//
//  BasePresenter.swift
//
//  Created by CodeVision on 2017. 04. 13..
//  Copyright © 2017. All rights reserved.
//

import UIKit

@objc protocol BasePresenterProtocol: class {
    func showSnackbar(with message: String)
    func showLoader()
    func hideLoader()
    func navigateBack()

    func handleUserNotLoggedIn()
}

class BasePresenter: NSObject, BasePresenterProtocol {

    required override init() {

    }

    var viewController: BaseViewController!

    var BaseContentViewController: BaseContentViewController? {

        return viewController as? BaseContentViewController
    }

    // MARK: conform to BasePresenterProtocol
    func showSnackbar(with message: String = "MainVC.SomeThingWrong".localized) {
        BaseContentViewController?.showSnackbar(with: message)
    }

    func showLoader() {
        BaseContentViewController?.showLoader()
    }

    func hideLoader() {
        BaseContentViewController?.hideLoader()
    }

    func navigateBack() {
        BaseContentViewController?.overrideHeaderBackButtonPressed()
    }

    func handleUserNotLoggedIn() {
        self.hideLoader()

        MainViewController.shared.loadFirstScreen()
    }

    func loadFirstScreen() {
        MainViewController.shared.loadFirstScreen()
    }
}
