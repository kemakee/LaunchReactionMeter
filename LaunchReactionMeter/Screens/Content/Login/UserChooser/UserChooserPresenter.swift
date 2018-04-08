//
//  UserChooserPresenter.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

@objc protocol UserChooserPresenterProtocol : BasePresenterProtocol{
    func navigateToRegistrationScreen()
}

class UserChooserPresenter: BasePresenter, UserChooserPresenterProtocol {
    func navigateToRegistrationScreen() {
        MainViewController.shared.load(content: RegistrationViewController())
    }
    

    
}
