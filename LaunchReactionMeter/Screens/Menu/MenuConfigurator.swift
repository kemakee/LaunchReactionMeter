//
//  MenuConfigurator.swift
//  Okosradiator
//
//  Created by Provender Roxána on 2018. 02. 23..
//  Copyright (c) 2018. CodeVision. All rights reserved.
//
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

class MenuConfigurator : BaseConfigurator {

    // MARK: - Configuration
    class func configureMenu(viewController : MenuViewController) {
        let menuInteractor: MenuInteractorProtocol = getInteractor()

        // configure  presenter
        let presenter = MenuPresenter()
        presenter.viewController = viewController

        // configure  viewcontroller
        viewController.interactor = menuInteractor

        // configure  interactor
        menuInteractor.registerPresenter(presenter)

    }

    static private func getInteractor() -> MenuInteractorProtocol {
        let interactor : MenuInteractorProtocol

        if let interactorProtocol = getInteractor(byProtocol: MenuInteractorProtocol.self) {
            interactor = interactorProtocol as! MenuInteractorProtocol
        } else {
            interactor = MenuInteractor()
            CoreEnvironment.shared.currentInteractor = interactor
        }

        return interactor
    }

}
