//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class ConfigurationLRMRegTextField: ConfigurationComponent{

    var lblText: String?
    var tfwidtherrorconfig: ConfigurationLRMTextFieldWithError
    var frame: CGRect
    var isPassword: Bool
    var isEditField: Bool
    var invisibleButton: UIButton!
    var textContainerLabel: Label!


    
    
    init(lblText: String?, hinttext: String?, text: String?, errorText: String?, frame: CGRect, isPassword: Bool = false, keyBoardType: UIKeyboardType = .default, isEditField: Bool = false)
    {
        self.tfwidtherrorconfig = ConfigurationLRMTextFieldWithError(hinttext: hinttext, text: text, errorText: errorText, frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), rightInset: isPassword == true ? LRMRegTextField.eyePaddingFromRight: 0.0, keyBoardType: keyBoardType)
        self.lblText = lblText
        self.frame = frame
        self.isPassword = isPassword
        self.isEditField = isEditField
        super.init()
        
    }
    
    
}
