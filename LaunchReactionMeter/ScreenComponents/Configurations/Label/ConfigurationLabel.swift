//
//  ConfigurationLabel.swift
//
//  Created by CodeVision on 2017. 04. 21..
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Foundation

class ConfigurationLabel: ConfigurationComponent {
    var size: CGSize
    var text: String
    var attributedText: NSAttributedString?
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var textColor: UIColor = UIColor.black
    var fitHeight: Bool = false
    var maxNumberOfLines: Int = 0
    var adjustFontSizeToWidth: Bool = false

    init(size: CGSize, text: String) {
        self.size = size
        self.text = text
        super.init()
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = ConfigurationLabel(size: self.size, text: self.text)
        copy.attributedText = self.attributedText
        copy.font = self.font
        copy.textColor = self.textColor
        copy.fitHeight = self.fitHeight
        copy.maxNumberOfLines = self.maxNumberOfLines
        copy.adjustFontSizeToWidth = self.adjustFontSizeToWidth
        return copy
    }

}
