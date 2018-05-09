//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class ConfigurationLRMTextField: ConfigurationComponent {

    var hintText: String?
    var text: String?
    var frame: CGRect
    var dateTypeNeeded = false
    var keyBoardType: UIKeyboardType = .default
    var rightInset: CGFloat = 0.0
    
    init(hinttext: String?, text: String?, frame: CGRect, rightInset: CGFloat = 0.0, keyBoardType: UIKeyboardType = .default)
    {
        self.keyBoardType = keyBoardType
        self.hintText = hinttext
        self.text = text
        self.frame = frame
        self.rightInset = rightInset
        super.init()
    }

    
}
