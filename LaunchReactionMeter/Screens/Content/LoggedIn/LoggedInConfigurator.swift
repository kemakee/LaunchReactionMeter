//
//  LoggedInConfigurator.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class LoggedInConfigurator: BaseConfigurator {
    
    class func configureLoggedInSegmentedController(viewController : SegmentedViewController) {
        let loginInteractor: LoggedInInteractorProtocol = getInteractor()
        
        // configure  presenter
        let presenter = SegmentedViewPresenter()
        presenter.viewController = viewController
        
        // configure  viewcontroller
        viewController.interactor = loginInteractor
        
        // configure  interactor
        loginInteractor.registerPresenter(presenter)
        
    }
    
    static private func getInteractor() -> LoggedInInteractorProtocol {
        let interactor : LoggedInInteractorProtocol
        
        if let interactorProtocol = getInteractor(byProtocol: LoggedInInteractorProtocol.self) {
            interactor = interactorProtocol as! LoggedInInteractorProtocol
        } else {
            interactor = LoggedInInteractor()
            CoreEnvironment.shared.currentInteractor = interactor
        }
        
        return interactor
    }

}
