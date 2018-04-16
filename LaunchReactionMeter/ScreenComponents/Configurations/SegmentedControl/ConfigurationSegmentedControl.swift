//
//  ConfigurationSegmentedControl.swift
//  ComeGetIt
//
//  Created by Ákos Kemenes on 2017. 07. 03..
//  Copyright © 2017. ComeGetIt. All rights reserved.
//

import UIKit

class ConfigurationSegmentedControl: ConfigurationComponent {
    
    var y: CGFloat
   
    var titles: [String]
    
    init ( y: CGFloat ,titles: [String])
    {
        self.y = y
        self.titles = titles
        super.init()
    }

}
