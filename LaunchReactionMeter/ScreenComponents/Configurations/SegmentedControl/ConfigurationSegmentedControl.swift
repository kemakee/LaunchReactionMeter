//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
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
