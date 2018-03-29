//
//  MenuPresenter.swift
//  Okosradiator
//
//  Created by Provender Roxána on 2018. 02. 23..
//  Copyright (c) 2018. CodeVision. All rights reserved.
//
//

import UIKit

@objc protocol MenuPresenterProtocol: BasePresenterProtocol {


}

class MenuPresenter: BasePresenter, MenuPresenterProtocol {

    var menuViewController : MenuViewController {

        return viewController as! MenuViewController
    }

 

}
