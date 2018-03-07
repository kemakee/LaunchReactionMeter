//
//  ConfigurationProtocol.swift
//  AppCore
//
//  Created by CodeVision on 26/05/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

protocol ConfigurationProtocol {

    init(configuration: ConfigurationComponent)

    func configure(_ configuration: ConfigurationComponent)

    func reconfigure(_ configuration: ConfigurationComponent)

    func getConfiguration() -> ConfigurationComponent
}
