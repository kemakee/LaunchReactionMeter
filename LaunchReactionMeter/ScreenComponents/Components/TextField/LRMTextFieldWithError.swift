//
//  LRMTextFieldWithError.swift
//  ComeGetIt
//
//  Created by Roxána Provender on 2017. 06. 21..
//  Copyright © 2017. ComeGetIt. All rights reserved.
//

import UIKit


@objc protocol LRMTextFieldWithErrorDelegate:  NSObjectProtocol {
    func errorTextFieldHeightChanged(_ tfwithError: LRMTextFieldWithError)
    @objc optional func textFieldShouldReturn(_ textField: LRMTextFieldWithError) -> Bool
}

class LRMTextFieldWithError: UIView, LRMTextFieldDelegate {

    
    required init(configuration: ConfigurationComponent) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.configure(configuration)
    }
    


    weak var delegate: LRMTextFieldWithErrorDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    var config: ConfigurationLRMTextFieldWithError!
    
    var textField: LRMTextField!
    var lblError: Label!
    
   func configure(_ configuration: ConfigurationComponent) {
        
        guard configuration is ConfigurationLRMTextFieldWithError else {
            return
        }
        
        self.subviews.forEach({$0.removeFromSuperview()})
        
        config = configuration as! ConfigurationLRMTextFieldWithError
        
        self.frame = config.frame
       
        
        textField = LRMTextField(configuration: config.textFieldconfig)
        textField.setNeedsDisplay()
        self.addSubview(textField)
        
        textField.LRMDelegate = self
        
        self.height = textField.height
        
        showError(errorText: config.errorText)
        
    }
    
    func showError(errorText: String?)
    {
        if (lblError) == nil {
            let errorconfig = ConfigurationLabel(size: CGSize( width: textField.width, height: UIScreen.scale(13)), text: "")
            lblError = Label(configuration: errorconfig)
            lblError.textColor = Constants.COLOR_LRM_RED
            lblError.font = Constants.LRM_TYPO_12
            lblError.origin = CGPoint(x: textField.x, y: textField.height + UIScreen.scale(4))
            
            self.addSubview(lblError)
        }
        
        
        if let Text = errorText
        {
            
            lblError.setTextAndResize(Text)
            self.height = config.frame.size.height + UIScreen.scale(5) + lblError.height
            
        }
        else
        {
            
            lblError.setTextAndResize("")
            self.height = (config.frame.size.height + UIScreen.scale(5))
            
        }
        
        delegate?.errorTextFieldHeightChanged(self)
    }
    
    var eyeImageView: UIImageView!
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = delegate?.textFieldShouldReturn?(self)
        {
            return text
        }
        else
        {
            return false
        }
        
    }
    

}
