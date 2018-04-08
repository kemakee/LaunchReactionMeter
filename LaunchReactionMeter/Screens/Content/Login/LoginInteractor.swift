//
//  LoginInteractor.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@objc protocol LoginInteractorProtocol : BaseInteractorProtocol {

    func navigateToRegistrationScreen()
    func doRegister(regData: RegistrationData)
    func navigateToUserChooser()
}
@objc enum textFieldType: Int{
    case email
    case name
    case password
}

class LoginInteractor: BaseInteractor, LoginInteractorProtocol {
    func navigateToRegistrationScreen() {
       let presenter = try! self.getLastPresenter(byProtocol: UserChooserPresenterProtocol.self) as! UserChooserPresenterProtocol
        presenter.navigateToRegistrationScreen()
    }
    func navigateToUserChooser()
    {
         let presenter = try! self.getLastPresenter(byProtocol: SuccessfulRegistrationPresenterProtocol.self) as! SuccessfulRegistrationPresenterProtocol
        presenter.navigateToUserChooser()
    }
    
    
    
//    func ValidateEmailAndPasswd(loginData: LoginData) -> Bool
//    {
////        var hasError = false
////        let presenter: EmailLoginPresenterProtocol = try! self.getLastPresenterByProtocol(EmailLoginPresenterProtocol.self) as! EmailLoginPresenterProtocol
////
////        presenter.hideAllError()
////
////        if loginData.email == nil || loginData.email == ""
////        {
////            presenter.showEmailEmptyError()
////            hasError=true
////        }
////        else if isValidEmail(testStr: loginData.email!) == false
////        {
////            presenter.showInvalidEmailError()
////            hasError = true
////        }
////
////        if loginData.password == nil || loginData.password! == ""
////        {
////            hasError = true
////            presenter.showEmptyPassWdError()
////        }
////        else if (loginData.password!.length) < 5
////        {
////            hasError = true
////            presenter.showSmallPasswordError()
////        }
////
////        return hasError
//    }
    
    func ValidateData(regData: RegistrationData) -> Bool
    {
        var hasError = false
        let presenter: RegistrationPresenterProtocol = try! self.getLastPresenter(byProtocol: RegistrationPresenterProtocol.self) as! RegistrationPresenterProtocol
        
        presenter.hideAllError()
        
        
        if regData.email != nil && regData.email != ""
        {
            if !isValidEmail(testStr: regData.email!)
            {
                hasError = true
                presenter.showNotValidEmailError()
            }
        }
        else
        {
            hasError = true
            presenter.showEmptyError(error: .email)
        }
        
        if let password = regData.password
        {
            if password != "" && password.length < 5
            {
                hasError = true
                presenter.showSmallPasswordError()
            }
            else if password == ""
            {
                hasError = true
                presenter.showEmptyError(error: .password)
            }
        }
   
        
        return hasError
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func doRegister(regData: RegistrationData) {
        
        let isError = ValidateData(regData: regData)
        
        if !isError
        {
            Auth.auth().createUser(withEmail: regData.email!, password: regData.password!, completion: { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    let presenter: RegistrationPresenterProtocol = try! self.getLastPresenter(byProtocol: RegistrationPresenterProtocol.self) as! RegistrationPresenterProtocol
                    presenter.doNavigateToSuccessScreen()
                    
                    
                } else {
                    print("notgud")
                }
            })
        }
    }

}
