//
//  BaseHeaderViewController.swift
//  AppCore
//
//  Created by CodeVision on 14/05/17.
//  Copyright (c) 2017 CodeVision. All rights reserved.
//

import UIKit

enum HeaderNavigationState {
    case none
    case menu
    case back
}

class BaseHeaderViewController: BaseViewController {

    var content: BaseContentViewController?

    var navigationState: HeaderNavigationState = HeaderNavigationState.none

    func setNavigationStateTo(_ state: HeaderNavigationState) {

    }
}
