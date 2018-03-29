//
//  UIScrollViewExtension.swift
//
//  Created by CodeVision on 2017. 10. 19..
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
