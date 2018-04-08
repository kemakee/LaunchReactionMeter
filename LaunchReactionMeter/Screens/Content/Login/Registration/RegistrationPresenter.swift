//
//  RegistrationPresenter.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

@objc protocol RegistrationPresenterProtocol : BasePresenterProtocol
{
    
    func showEmptyError(error: textFieldType)
    
    func showNotValidEmailError()
    
    func showSmallPasswordError()
    
    func hideAllError()
    
     func showRegistrationSuccessScreen()
    
   func doNavigateToSuccessScreen()
}

class RegistrationPresenter: BasePresenter,RegistrationPresenterProtocol {
    
    
    var registrationVC: RegistrationViewController {
        
        return viewController as! RegistrationViewController
    }
    

    
    func showEmptyError(error: textFieldType) {
        
        switch error {
        case .email:
            
            registrationVC.emailField.showError(errorText: "empty email adrress")
            
        case .name:
            
            registrationVC.nameField.showError(errorText: "emtpy name field")
        
            
        case .password:
            
            if let password = registrationVC.passwordField
            {
                password.showError(errorText: "empty password field")
            }
            
      
        
        }
    }
    
    func showNotValidEmailError() {
        
        registrationVC.emailField.showError(errorText: "not valid email")
    }
    
    func showSmallPasswordError() {
        
        registrationVC.passwordField.showError(errorText: "too short password")
        
    }
    
    func hideAllError() {
        
        
        if let password = registrationVC.passwordField
        {
            password.showError(errorText: nil)
        }
        
        registrationVC.emailField.showError(errorText: nil)

    }
    
    
    func showRegistrationSuccessScreen() {
        
//        MainViewController.sharedInstance().clearSavedContents()
//        MainViewController.sharedInstance().loadContent(SuccessViewController(), savingLastContent: false, animationEnabled: true, needHeader: true)
    }
    
     func doNavigateToSuccessScreen()
     {
        MainViewController.shared.replace(content: SuccessfulRegistrationViewController())
    }

}
