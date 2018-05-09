//
//  LoginConfigurator.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class LoginConfigurator: BaseConfigurator {
    
    class func configureLoginController(viewController : LoginViewController) {
        let loginInteractor: LoginInteractorProtocol = getInteractor()
        
        // configure  presenter
        let presenter = LoginPresenter()
        presenter.viewController = viewController
        
        // configure  viewcontroller
        viewController.interactor = loginInteractor
        
        // configure  interactor
        loginInteractor.registerPresenter(presenter)
        
    }
    
    
    class func configureSuccessfulControler(viewController : SuccessfulRegistrationViewController) {
        let loginInteractor: LoginInteractorProtocol = getInteractor()
        
        // configure  presenter
        let presenter = SuccessfulRegistrationPresenter()
        presenter.viewController = viewController
        
        // configure  viewcontroller
        viewController.interactor = loginInteractor
        
        // configure  interactor
        loginInteractor.registerPresenter(presenter)
        
    }
    
    
    class func configureRegistrationViewControler(viewController : RegistrationViewController) {
        let loginInteractor: LoginInteractorProtocol = getInteractor()
        
        // configure  presenter
        let presenter = RegistrationPresenter()
        presenter.viewController = viewController
        
        // configure  viewcontroller
        viewController.interactor = loginInteractor
        
        // configure  interactor
        loginInteractor.registerPresenter(presenter)
        
    }
    
    
    class func configureUserChooserViewControler(viewController : UserChooserViewController) {
        let loginInteractor: LoginInteractorProtocol = getInteractor()
        
        // configure  presenter
        let presenter = UserChooserPresenter()
        presenter.viewController = viewController
        
        // configure  viewcontroller
        viewController.interactor = loginInteractor
        
        // configure  interactor
        loginInteractor.registerPresenter(presenter)
        
    }
    
    class func configureForgotController(viewController : ForgotPasswordViewController) {
        let loginInteractor: LoginInteractorProtocol = getInteractor()
        
        // configure  presenter
        let presenter = ForgotPasswordPresenter()
        presenter.viewController = viewController
        
        // configure  viewcontroller
        viewController.interactor = loginInteractor
        
        // configure  interactor
        loginInteractor.registerPresenter(presenter)
        
    }
    
    
    static private func getInteractor() -> LoginInteractorProtocol {
        let interactor : LoginInteractorProtocol
        
        if let interactorProtocol = getInteractor(byProtocol: LoginInteractorProtocol.self) {
            interactor = interactorProtocol as! LoginInteractorProtocol
        } else {
            interactor = LoginInteractor()
            CoreEnvironment.shared.currentInteractor = interactor
        }
        
        return interactor
    }
    
    
}
