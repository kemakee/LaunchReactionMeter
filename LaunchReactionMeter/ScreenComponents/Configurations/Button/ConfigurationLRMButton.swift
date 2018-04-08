//
//  ConfigurationCGIButton.swift
//  ComeGetIt
//
//  Created by Ákos Kemenes on 2017. 06. 21..
//  Copyright © 2017. ComeGetIt. All rights reserved.
//

import UIKit
enum colorType {
    case gray
    case orange
    case white

}
enum sizeType {
    case normal
    case custom
}
class ConfigurationLRMButton: ConfigurationComponent {
    
    
    var text: String
    var y: CGFloat
    var color: colorType
    var size: sizeType
    var frame: CGRect?
    
    init (y: CGFloat, text: String, color: colorType, size: sizeType, frame: CGRect? = nil)
    {
        self.text = text
        self.y = y
        self.color = color
        self.size = size
        self.frame = frame
        super.init()
        
    }
}
