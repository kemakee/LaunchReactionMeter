//
//  SuccessfulRegistrationViewController.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class SuccessfulRegistrationViewController: BaseContentViewController {

    var succesLabel : Label!
    var okButton : LRMButton!
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
        
        
        LoginConfigurator.configureSuccessfulControler(viewController: self)
        
        
        let configlbl = ConfigurationLabel(size: CGSize(width: UIScreen.screenWidth*0.90, height: UIScreen.scale(50)), text: "You have successfully registred")
        succesLabel = Label(configuration: configlbl)
        succesLabel.textColor = Constants.COLOR_LRM_ORANGE
        succesLabel.font = Constants.LRM_TYPO_20
        self.svContent.addSubview(succesLabel)
        
        
        let configOkBtn = ConfigurationLRMButton(y: 0, text: "Ok, let's do it!", color: .orange, size: .normal)
        okButton = LRMButton(configuration: configOkBtn)
        self.svContent.addSubview(okButton)
        okButton.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
    
        
        self.view.setNeedsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        succesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(UIScreen.screenHeight/4)
            make.left.equalTo((UIScreen.screenWidth/2-succesLabel.width/2))
            make.width.equalTo(succesLabel.width)
            make.height.equalTo(succesLabel.height)
        }
        
        okButton.snp.makeConstraints { (make) in
            make.top.equalTo(UIScreen.screenHeight*0.80)
            make.left.equalTo((UIScreen.screenWidth/2-okButton.width/2))
            make.width.equalTo(okButton.width)
            make.height.equalTo(okButton.height)
        }
        

        
        
    }
    
    @objc func okButtonPressed()
    {
        loginInteractor.navigateToUserChooser()
    }

}
