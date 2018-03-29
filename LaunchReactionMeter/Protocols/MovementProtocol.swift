//
//  MovementProtocol.swift
//  AppCore
//
//  Created by Codevision iMac on 2018. 01. 12..
//  Copyright © 2018. CodeVision. All rights reserved.
//
import UIKit
import Foundation

@objc protocol MovementProtocol {

    func drag(delta: CGFloat, completionHandler: (() -> Void)?)

    func animateIn(completionHandler: (() -> Void)?)

    func animateOut(completionHandler: (() -> Void)?)

    @objc optional func beforeSlide()

    @objc optional func afterSlide()
}
