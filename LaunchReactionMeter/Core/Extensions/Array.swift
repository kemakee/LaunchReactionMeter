//
//  Array.swift
//
//  Created by CodeVision on 2018. 01. 11..
//  Copyright © 2018. CodeVision. All rights reserved.
//

import UIKit
import Foundation

extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
