//
//  ForgotPasswordViewController.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 05. 09..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseContentViewController, LRMRegTextFieldDelegate {
    
    
    var emailField : LRMRegTextField!
    var sendButton : LRMButton!
    var ScreenComponent: [UIView] = []
    
    let padding = UIScreen.scale(8)
    var loginInteractor: LoginInteractorProtocol {
        
        return interactor as! LoginInteractorProtocol
    }
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func initLayout() {
        super.initLayout()
        self.svContent.isScrollEnabled = false
        self.svContent.backgroundColor = Constants.COLOR_LRM_BLACK
        
        
        LoginConfigurator.configureForgotController(viewController: self)
        
        let configEmailField = ConfigurationLRMRegTextField(lblText: "e-mail", hinttext: nil, text: "kemi@inf.elte.hu", errorText: nil, frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth*0.75, height: UIScreen.scale(30)), isPassword: false, keyBoardType: UIKeyboardType.emailAddress, isEditField: false)
        emailField = LRMRegTextField(configuration: configEmailField)
        emailField.delegate = self
        emailField.tag = 0
        ScreenComponent.append(emailField)
        self.svContent.addSubview(emailField)
        
      
        
        
        let configSendBtn : ConfigurationLRMButton = ConfigurationLRMButton(y: 0, text: "Send", color: .orange, size: .normal)
        sendButton = LRMButton(configuration: configSendBtn)
        self.svContent.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        
        
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
        
 
        
        sendButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(UIScreen.screenHeight*0.80)
            make.left.equalTo((UIScreen.screenWidth/2-sendButton.width/2))
            make.width.equalTo(sendButton.width)
            make.height.equalTo(sendButton.height)
        }
        
        
    }
    
    @objc func sendPressed()
    {
      
        loginInteractor.sendForgotPassword(email: emailField.tfdWidthError.textField.text!)
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
