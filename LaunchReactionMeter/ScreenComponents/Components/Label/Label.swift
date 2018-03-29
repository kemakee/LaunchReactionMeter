//
//  Label.swift
//  AppCore
//
//  Created by CodeVision on 30/05/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import UIKit

class Label: UILabel, ConfigurationProtocol {
    private var config: ConfigurationLabel!

    required init(configuration: ConfigurationComponent) {
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.configure(configuration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ configuration: ConfigurationComponent) {
        guard configuration is ConfigurationLabel else {
            return
        }

        self.config = configuration as! ConfigurationLabel

        size = config.size
        font = config.font
        textColor = config.textColor
        text = config.text
        if config.attributedText != nil {
            attributedText = config.attributedText
        }
        numberOfLines = config.maxNumberOfLines
        adjustsFontSizeToFitWidth = config.adjustFontSizeToWidth

        if config.fitHeight {
            fitHeight()
        }
    }

    func reconfigure(_ configuration: ConfigurationComponent) {
        guard configuration is ConfigurationLabel else {
            return
        }
        let reconfig = configuration as! ConfigurationLabel

        var doFitHeight = false

        if config.size != reconfig.size {
            self.size = reconfig.size
            doFitHeight = reconfig.fitHeight
        }

        if config.text != reconfig.text {
            text = reconfig.text
            doFitHeight = reconfig.fitHeight
        }

        if config.attributedText != reconfig.attributedText {
            attributedText = reconfig.attributedText
            doFitHeight = reconfig.fitHeight
        }

        if config.font != reconfig.font {
            font = reconfig.font
            doFitHeight = reconfig.fitHeight
        }

        if config.textColor != reconfig.textColor {
            textColor = reconfig.textColor
        }

        if config.maxNumberOfLines != reconfig.maxNumberOfLines {
            numberOfLines = reconfig.maxNumberOfLines
            doFitHeight = reconfig.fitHeight
        }

        if config.adjustFontSizeToWidth != reconfig.adjustFontSizeToWidth {
            adjustsFontSizeToFitWidth = reconfig.adjustFontSizeToWidth
            doFitHeight = reconfig.fitHeight
        }

        if doFitHeight {
            self.fitHeight()
        }

        config = reconfig
    }

    func getConfiguration() -> ConfigurationComponent {
        return config.copy() as! ConfigurationLabel
    }

    private func fitHeight() {
        let minHeightByText = text!.getMinimumHeight(withFont: self.font, andWidthConstraint: self.width)
        height = min(minHeightByText, getMaximumHeightByLines())
    }

    private func getMaximumHeightByLines() -> CGFloat {
        let height: CGFloat = font.lineHeight * CGFloat(self.numberOfLines)
        return height == 0 ? CGFloat.greatestFiniteMagnitude : height
    }

}