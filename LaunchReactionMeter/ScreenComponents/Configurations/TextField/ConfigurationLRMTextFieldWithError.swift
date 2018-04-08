//
//  ConfigurationLRMTextFieldWithError.swift
//  ComeGetIt
//
//  Created by Roxána Provender on 2017. 06. 21..
//  Copyright © 2017. ComeGetIt. All rights reserved.
//

import UIKit

class ConfigurationLRMTextFieldWithError: ConfigurationComponent {
    
    var textFieldconfig: ConfigurationLRMTextField
    var errorText: String?
    var frame: CGRect
    
    init(hinttext: String?, text: String?, errorText: String?, frame: CGRect, rightInset: CGFloat = 0.0, keyBoardType: UIKeyboardType = .default)
    {
        self.frame = frame
        self.textFieldconfig = ConfigurationLRMTextField(hinttext: hinttext, text: text, frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), rightInset: rightInset, keyBoardType: keyBoardType)
        self.errorText = errorText
        super.init()
        
    }
    

}
