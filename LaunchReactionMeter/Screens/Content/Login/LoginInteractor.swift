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
    func doRegister(regData: UserData)
    func navigateToUserChooser()
    func navigateToLogin(_ userType : UserType)
    func doLogin(loginData : UserData, _ userType : UserType)
    func ValidateEmailAndPasswd(loginData: UserData) -> Bool
}
@objc enum textFieldType: Int{
    case email
    case name
    case password
}

class LoginInteractor: BaseInteractor, LoginInteractorProtocol {
    
    
    func doRegister(regData: UserData) {
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
    
    func ValidateEmailAndPasswd(loginData: UserData) -> Bool {
        var hasError = false
        let presenter: LoginPresenterProtocol = try! self.getLastPresenter(byProtocol: LoginPresenterProtocol.self) as! LoginPresenterProtocol
        
        presenter.hideAllError()
        
        if loginData.email == nil || loginData.email == ""
        {
            presenter.showEmptyError(error: .email)
            hasError=true
        }
        else if isValidEmail(testStr: loginData.email!) == false
        {
            presenter.showNotValidEmailError()
            hasError = true
        }
        
        if loginData.password == nil || loginData.password! == ""
        {
            hasError = true
            presenter.showEmptyError(error: .password)
        }
        else if (loginData.password!.length) < 5
        {
            hasError = true
            presenter.showSmallPasswordError()
        }
        
        return hasError
    }
    

    
    func navigateToRegistrationScreen() {
       let presenter = try! self.getLastPresenter(byProtocol: UserChooserPresenterProtocol.self) as! UserChooserPresenterProtocol
        presenter.navigateToRegistrationScreen()
    }
    
    func navigateToUserChooser()
    {
         let presenter = try! self.getLastPresenter(byProtocol: SuccessfulRegistrationPresenterProtocol.self) as! SuccessfulRegistrationPresenterProtocol
        presenter.navigateToUserChooser()
    }
    
    func navigateToLogin(_ userType: UserType)
    {
        let presenter = try! self.getLastPresenter(byProtocol: UserChooserPresenterProtocol.self) as! UserChooserPresenterProtocol
        presenter.navigateToLogin(userType)
    }
    
    func doLogin(loginData: UserData, _ userType: UserType) {
        let presenter = try! self.getLastPresenter(byProtocol: LoginPresenterProtocol.self) as! LoginPresenterProtocol
        if !ValidateEmailAndPasswd(loginData: loginData)
        {
            presenter.disableButton()
            Auth.auth().signIn(withEmail: loginData.email!, password: loginData.password!) { (user, error) in
                
                if error == nil {
                    presenter.navigateToLoggedIn(userType)
                    CoreEnvironment.shared.userType = userType
                    
                } else {
              
                    presenter.showWrongEmailOrPassword()
                    presenter.enableButton()
                }
                
            }
            
        }
       
        
    }
    
    
    func ValidateData(regData: UserData) -> Bool
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
    
 

}
