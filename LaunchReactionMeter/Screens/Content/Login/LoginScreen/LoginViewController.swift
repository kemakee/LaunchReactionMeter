//
//  LoginViewController.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 11..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class LoginViewController: BaseContentViewController, LRMRegTextFieldDelegate {

    var nameField : LRMRegTextField!
    var passwordField : LRMRegTextField!
    var emailField : LRMRegTextField!
    var loginButton : LRMButton!
    var ScreenComponent: [UIView] = []
    
    let padding = UIScreen.scale(8)
    var logoIV : UIImageView!
    var userType : UserType!
    var loginInteractor: LoginInteractorProtocol {
        
        return interactor as! LoginInteractorProtocol
    }
    
    init(_ userType : UserType)
    {
        self.userType = userType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func initLayout() {
        super.initLayout()
        self.svContent.isScrollEnabled = false
        self.svContent.backgroundColor = Constants.COLOR_LRM_BLACK
        
        
        LoginConfigurator.configureLoginController(viewController: self)
        
        let configEmailField = ConfigurationLRMRegTextField(lblText: "e-mail", hinttext: nil, text: "kemi@inf.elte.hu", errorText: nil, frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth*0.75, height: UIScreen.scale(30)), isPassword: false, keyBoardType: UIKeyboardType.emailAddress, isEditField: false)
        emailField = LRMRegTextField(configuration: configEmailField)
        emailField.delegate = self
        emailField.tag = 0
        ScreenComponent.append(emailField)
        self.svContent.addSubview(emailField)
        
        let configPasswordField = ConfigurationLRMRegTextField(lblText: "password", hinttext: nil, text: "Xxx.akos", errorText: nil, frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth*0.75, height: UIScreen.scale(30)), isPassword: true, keyBoardType: UIKeyboardType.alphabet, isEditField: false)
        passwordField = LRMRegTextField(configuration: configPasswordField)
        passwordField.delegate = self
        passwordField.tag = 0
        ScreenComponent.append(passwordField)
        self.svContent.addSubview(passwordField)
        
        
        
        
        let configLoginBtn : ConfigurationLRMButton = ConfigurationLRMButton(y: 0, text: "Login", color: .orange, size: .normal)
        loginButton = LRMButton(configuration: configLoginBtn)
        self.svContent.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
        
        self.view.setNeedsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        emailField.snp.makeConstraints { (make) in
            make.top.equalTo(UIScreen.scale(5))
            make.left.equalTo((UIScreen.screenWidth/2-emailField.width/2))
            make.width.equalTo(emailField.width)
            make.height.equalTo(emailField.height)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(emailField.snp.bottom).offset(padding)
            make.left.equalTo((UIScreen.screenWidth/2-passwordField.width/2))
            make.width.equalTo(passwordField.width)
            make.height.equalTo(passwordField.height)
        }
        
        
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(UIScreen.screenHeight*0.80)
            make.left.equalTo((UIScreen.screenWidth/2-loginButton.width/2))
            make.width.equalTo(loginButton.width)
            make.height.equalTo(loginButton.height)
        }
        
        
    }
    
    @objc func loginPressed()
    {
        let loginData = UserData(password: passwordField.tfdWidthError.textField.text!, email: emailField.tfdWidthError.textField.text!)
        loginInteractor.doLogin(loginData: loginData, userType)
        
    }
    
    func regTextFieldHeightChanged(_ tfreg: LRMRegTextField, different: CGFloat) {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            for index in 1...self.ScreenComponent.count-1
            {
                self.ScreenComponent[index].frame.origin.y = self.ScreenComponent[index].frame.origin.y + different
                
            }
            
        }, completion: { (Bool) in
            
        })
        
        
        self.contentHeight = ScreenComponent.last!.y + ScreenComponent.last!.height + UIScreen.scale(10)
        
    }


}
