//
//  NSMutableAttributedStringExtension.swift
//  AppCore
//
//  Created by Codevision iMac on 2018. 01. 19..
//  Copyright © 2018. CodeVision. All rights reserved.
//
import UIKit
import Foundation

extension NSMutableAttributedString {

    func set(font: UIFont, forContainedText text: String) {
        let range = self.mutableString.range(of: text, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedStringKey.font, value: font, range: range)
        }
    }

    func set(color: UIColor, forContainedText text: String) {
        let range = self.mutableString.range(of: text, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
    }

}
