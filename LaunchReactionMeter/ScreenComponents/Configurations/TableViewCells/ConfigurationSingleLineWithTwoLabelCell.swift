//
//  ConfigurationSingleLineWithTwoLabelCell.swift
//  LaunchReactionMeter
//
//  Created by Adam Horvath on 2018. 05. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class ConfigurationSingleLineWithTwoLabelCell: ConfigurationComponent {
    var dataText : String!
    var resultText : String!

    init(dataText: String, resultText: String) {
        super.init()
        self.dataText = dataText
        self.resultText = resultText
    }
}
