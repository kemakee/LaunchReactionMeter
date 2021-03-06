//
//  LoginPresenter.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 11..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

@objc protocol LoginPresenterProtocol : BasePresenterProtocol
{
    func navigateToLoggedIn(_ userType: UserType)
    
    func showEmptyError(error: textFieldType)
    
    func showNotValidEmailError()
    
    func showSmallPasswordError()
    
    func hideAllError()
    
    func showWrongEmailOrPassword()
    
    func enableButton()
    
    func disableButton()
    
    func navigateToForgot()
}
class LoginPresenter: BasePresenter, LoginPresenterProtocol {
    func navigateToForgot() {
        MainViewController.shared.load(content: ForgotPasswordViewController(), needHeader: true)
    }
    
  
    
    func navigateToLoggedIn(_ userType: UserType) {
         MainViewController.shared.replace(content: SegmentedViewController(userType), needHeader: false)
    }
    
    
    var loginVC: LoginViewController {
        
        return viewController as! LoginViewController
    }
    
    
    func enableButton() {
        loginVC.loginButton.isEnabled=true
    }
    
    func disableButton() {
        loginVC.loginButton.isEnabled=false
    }
    func showEmptyError(error: textFieldType) {
        
        switch error {
        case .email:
            
            loginVC.emailField.showError(errorText: "empty email adrress")
            
        case .name:
            
            loginVC.nameField.showError(errorText: "emtpy name field")
            
            
        case .password:
            
            if let password = loginVC.passwordField
            {
                password.showError(errorText: "empty password field")
            }
            
            
            
        }
    }
    
    func showWrongEmailOrPassword()
    {
        loginVC.emailField.showError(errorText: "wrong email or password")
        loginVC.passwordField.showError(errorText: "wrong email or password")
    }
    
    func showNotValidEmailError() {
        
        loginVC.emailField.showError(errorText: "not valid email")
    }
    
    func showSmallPasswordError() {
        
        loginVC.passwordField.showError(errorText: "too short password")
        
    }
    
    func hideAllError() {
        
        
        if let password = loginVC.passwordField
        {
            password.showError(errorText: nil)
        }
        
        loginVC.emailField.showError(errorText: nil)
        
    }

}
