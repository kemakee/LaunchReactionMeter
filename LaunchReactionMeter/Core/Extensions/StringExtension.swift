//
//  StringExtension.swift
//  AppCore
//
//  Created by CodeVision on 09/10/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit
import Foundation

extension String {

    var length: Int {
        return NSString(string: self).length
    }
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    func getMinimumSize(withFont font: UIFont, constrainedTo size: CGSize) -> CGSize {
        return self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size
    }

    func getMinimumWidth(withFont font: UIFont, andHeightConstraint height: CGFloat = UIScreen.screenHeight) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        return self.getMinimumSize(withFont: font, constrainedTo: constraintRect).width
    }

    func getMinimumHeight(withFont font: UIFont, andWidthConstraint width: CGFloat = UIScreen.screenWidth) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return self.getMinimumSize(withFont: font, constrainedTo: constraintRect).height
    }

    func getRowHeight(withFont font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return self.getMinimumSize(withFont: font, constrainedTo: constraintRect).height
    }

    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")

        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }

    func getFirstPosition(of text: String) -> NSRange? {
        if let firstPos = self.range(of: text) {
            let startPos = self.distance(from: self.startIndex, to: firstPos.lowerBound)
            let endPos = self.distance(from: self.startIndex, to: firstPos.upperBound)
            return NSRange(location:startPos, length:endPos-startPos)
        }
        return nil
    }

    func getPosition(of text: String) -> [NSRange] {
        var positions = [NSRange]()
        if let pos = text.range(of: self) {
            let startPos = self.distance(from: self.startIndex, to: pos.lowerBound)
            let endPos = self.distance(from: self.startIndex, to: pos.upperBound)
            positions.append(NSRange(location:startPos, length:endPos-startPos))
        }
        return positions
    }

    func getNumberOfLines(withFont font: UIFont, constrainedToSize size: CGSize) -> Int {
        return Int(ceilf(Float(size.height / font.lineHeight)))
    }

    func formatToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = NSTimeZone.system

        return (dateFormatter.date(from: self))
    }

    func formatToEuropianDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.system

        return (dateFormatter.date(from: self))
    }

    func formatToDateWithHourAndMinute() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        dateFormatter.timeZone = NSTimeZone.system

        return (dateFormatter.date(from: self))
    }

    func stringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }

    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }

    struct NumFormatter {
        static let instance = NumberFormatter()
    }

    var doubleValue: Double? {
        return NumFormatter.instance.number(from: self)?.doubleValue
    }

    var integerValue: Int? {
        return NumFormatter.instance.number(from: self)?.intValue
    }
    
    func getFrame(withFont font: UIFont!, constrainedToSize size: CGSize) -> CGSize{
        let attributesDictionary: NSDictionary = [NSAttributedStringKey.font: font]
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let frame: CGRect = self.boundingRect(with: size, options: options, attributes: attributesDictionary as? [NSAttributedStringKey: AnyObject], context: nil)
        
        return frame.size
    }

}
