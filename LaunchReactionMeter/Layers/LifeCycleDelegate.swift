//
//  LifeCycleDelegate.swift
//
//  Created by CodeVision on 14/05/17.
//  Copyright (c) 2017. All rights reserved.
//

import Foundation

@objc protocol LifeCycleDelegate {
    @objc optional func afterInstantiation()

    @objc optional func beforeLoad()

    @objc optional func afterLoad()

    @objc optional func beforeRefresh()

    @objc optional func afterRefresh()

    @objc optional func willRemoveFromSuperview()

    @objc optional func beforeDeallocation()

}
