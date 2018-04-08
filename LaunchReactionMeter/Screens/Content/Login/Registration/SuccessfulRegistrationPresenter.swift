//
//  SuccessfulRegistrationPresenter.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
@objc protocol SuccessfulRegistrationPresenterProtocol : BasePresenterProtocol
{
    func navigateToUserChooser()
}

class SuccessfulRegistrationPresenter: BasePresenter, SuccessfulRegistrationPresenterProtocol {

    func navigateToUserChooser()
    {
        MainViewController.shared.replace(content: UserChooserViewController())
    }
}
