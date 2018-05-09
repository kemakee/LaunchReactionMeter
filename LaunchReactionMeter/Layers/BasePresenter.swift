//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

@objc protocol BasePresenterProtocol: class {
    func showSnackbar(with message: String)
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
