//
//  LRMTextField.swift
//  ComeGetIt
//
//  Created by Roxána Provender on 2017. 06. 21..
//  Copyright © 2017. ComeGetIt. All rights reserved.
//

import UIKit



enum Visable {
    case nonVisable
    case visable
}

@objc protocol LRMTextFieldDelegate: NSObjectProtocol{
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class LRMTextField: UITextField, UITextFieldDelegate {
    
    weak var LRMDelegate: LRMTextFieldDelegate?
    
    var config: ConfigurationLRMTextField!
    
    var datePickerView: UIDatePicker!
    

    
    required init(configuration: ConfigurationComponent) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        self.configure(configuration)
        self.isAccessibilityElement = true
    }
    
    func drawText(in rect: CGRect, insets: UIEdgeInsets) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.scale(60))
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if config != nil && config!.rightInset > CGFloat(0.0) {
            
            return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0,  config!.rightInset ))
        }else{
            if let btnClear = getClearButton() {
                return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0, btnClear.width))
            }
            
        }
        return bounds
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        if config != nil && config!.rightInset > CGFloat(0.0) {
            return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0,  config!.rightInset ))
        } else {
            if let btnClear = getClearButton() {
                return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0, btnClear.width))
            }
            
        }
        return bounds
    }
    
    func configure(_ configuration: ConfigurationComponent) {
        
        guard configuration is ConfigurationLRMTextField else {
            return
        }
        
        config = configuration as! ConfigurationLRMTextField
        self.keyboardType=config.keyBoardType
        self.frame = config.frame
        self.height = config.frame.size.height + UIScreen.scale(5) //bordersize hozzádadása hogy az alsó border látszódjon
        self.layer.borderColor = Constants.COLOR_LRM_BLACK.cgColor
        self.backgroundColor = Constants.COLOR_LRM_BLACK
        self.textColor = UIColor.white
        self.setBottomBorder(color: Constants.COLOR_LRM_ORANGE)
        self.tintColor = Constants.COLOR_LRM_ORANGE
        self.clearButtonMode = UITextFieldViewMode.always
        self.delegate = self
        self.font = Constants.LRM_TYPO_14
        
        if let HintText = config.hintText
        {
            self.placeholder = HintText
        }
        
        if let Text = config.text
        {
            self.text = Text
        }
        
        if config.dateTypeNeeded
        {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            
            datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            
            if let text = config.text
            {
                datePickerView.date = dateFormatter.date(from: text)!
            }
            
            self.inputView = datePickerView
            datePickerView.maximumDate = today()
            datePickerView.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeClearButtonColour()
    }
    
    func changeClearButtonColour()
    {
        if let btnClear = getClearButton() {
            if let uiImage = btnClear.image(for: .normal) {
                btnClear.setImage(uiImage.imageWithColor(Constants.COLOR_LRM_ORANGE), for: .normal)
                btnClear.setImage(uiImage.imageWithColor(Constants.COLOR_LRM_ORANGE), for: .highlighted)
            }
            
        }
    }
    
    func getClearButton()->UIButton?{
        for view in subviews {
            if view is UIButton {
                return (view as! UIButton)
            }
        }
        
        return nil
    }
    
    func setBottomBorder(color: UIColor) {
        
        self.borderStyle = .none
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: UIScreen.scale(2))
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        if let text = LRMDelegate?.textFieldShouldReturn?(self)
        {
            return text
        }
        else
        {
            return false
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        
        self.text = dateFormatter.string(from: sender.date)
        
    }
    
    func today() -> Date
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = Date()
        let today = dateFormatter.string(from: date)
        
        let todayDate = dateFormatter.date(from: today)
        
        return todayDate!
        
    }
    
    func setDatePickerTo(_ date: Date, animated: Bool){
        
        datePickerView.setDate(date, animated: animated)
        
    }
    
    
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if ((action == #selector(UIResponderStandardEditActions.paste(_:)) || (action == #selector(UIResponderStandardEditActions.cut(_:)))) && datePickerView != nil) {
            return nil
        }
        return super.target(forAction: action, withSender: sender)
    }
    
}
