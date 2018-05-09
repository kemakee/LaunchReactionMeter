//
//  ForgotPasswordPresenter.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 05. 09..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
@objc protocol ForgotPasswordPresenterProtocol : BasePresenterProtocol
{
    func showSuccedPasswordChangeEmail()
    func navigateToLogin()
    func showEmailError()
}
class ForgotPasswordPresenter: BasePresenter, ForgotPasswordPresenterProtocol {
   
    
    
    var forgotVC: ForgotPasswordViewController {
        
        return viewController as! ForgotPasswordViewController
    }
    
    func showEmailError() {
        forgotVC.showSnackbar(with: "Something wrong happend. Maybe wrong email.")
    }
    
    
    func showSuccedPasswordChangeEmail() {
        forgotVC.showSnackbar(with: "An e-mail sent, with your password reminder")
    }
    
    func navigateToLogin() {
        MainViewController.shared.navigateBack()
    }
    

}
