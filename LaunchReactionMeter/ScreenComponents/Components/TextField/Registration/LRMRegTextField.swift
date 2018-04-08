//
//  LRMRegTextField.swift
//  ComeGetIt
//
//  Created by Roxána Provender on 2017. 06. 22..
//  Copyright © 2017. ComeGetIt. All rights reserved.
//

import UIKit


protocol LRMRegTextFieldDelegate: class {
    func regTextFieldHeightChanged(_ tfreg: LRMRegTextField, different: CGFloat)
}

enum Editing {
    case editing
    case nonEditing
}

class LRMRegTextField: UIView, LRMTextFieldWithErrorDelegate {
    
    
    required init(configuration: ConfigurationComponent) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.configure(configuration)
    }
    
    
    var config: ConfigurationLRMRegTextField!
    static var imageWidth: CGFloat = UIScreen.scale(22)
    static var eyePaddingFromRight: CGFloat = UIScreen.scale(50)
    static var pencilPaddingFromRight: CGFloat = UIScreen.scale(20)
    
    weak var delegate: LRMRegTextFieldDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    
    var lblUpperText: Label!
    var tfdWidthError: LRMTextFieldWithError!
    var textEditLabel: Label!
    var invisibleButtonForTextEdit = UIButton(type: .custom)
    var pencilImageView: UIImageView!
    
    
    
    
    func configure(_ configuration: ConfigurationComponent) {
        
        guard configuration is ConfigurationLRMRegTextField else {
            return
        }
        
        
        config = configuration as! ConfigurationLRMRegTextField
        
        
        self.frame = config.frame
        self.backgroundColor = Constants.COLOR_LRM_BLACK
        
        
        tfdWidthError = LRMTextFieldWithError(configuration: config.tfwidtherrorconfig)
        self.addSubview(tfdWidthError)
        self.tfdWidthError.delegate=self
        
        self.height = (tfdWidthError.height + UIScreen.scale(5))

        if lblUpperText == nil
        {
            if let title = config.lblText {
                let lblconfig = ConfigurationLabel(size: CGSize( width: config.frame.size.width, height: UIScreen.scale(25)), text: title)
                lblUpperText = Label(configuration: lblconfig)
                lblUpperText.textColor = UIColor.white
                lblUpperText.backgroundColor = Constants.COLOR_LRM_BLACK
                lblUpperText.font = Constants.LRM_TYPO_14
                self.addSubview(lblUpperText)
            }
        } else if let title = config.lblText {
            lblUpperText.setTextAndResize(config.lblText!)
        } else {
            lblUpperText.removeFromSuperview()
        }

        tfdWidthError.y = lblUpperText.y + lblUpperText.height
        tfdWidthError.height = config.frame.height - lblUpperText.height
        tfdWidthError.textField.textColor = Constants.COLOR_LRM_ORANGE
        tfdWidthError.textField.autocapitalizationType = .none
        
        showError(errorText: config.tfwidtherrorconfig.errorText)
        
        
        if config.isPassword
        {
            
            tfdWidthError.textField.isSecureTextEntry = true
    
        }
        
        
        
        if config.isEditField
        {
            invisibleButtonForTextEdit = UIButton(type: .custom)
            
            invisibleButtonForTextEdit.frame = CGRect(x: 0, y: 0, width: self.width , height: self.height)
            invisibleButtonForTextEdit.backgroundColor = UIColor.clear
            invisibleButtonForTextEdit.addTarget(self, action: #selector(self.invBtnPressed), for: .touchUpInside)
            addSubview(invisibleButtonForTextEdit)
            
            self.tfdWidthError.textField.font = Constants.LRM_TYPO_18
            
            let  configTEL = ConfigurationLabel(size: CGSize(width: self.width , height: Constants.LRM_TYPO_18.pointSize), text: "")
            
            textEditLabel = Label(configuration: configTEL)
            textEditLabel.origin = CGPoint(x: self.tfdWidthError.x, y: self.tfdWidthError.y + UIScreen.scale(6))
            textEditLabel.textColor = Constants.COLOR_LRM_ORANGE
            
            
            setLabelCharSpaceing(inText: tfdWidthError.textField.text)
            
            self.addSubview(textEditLabel)
            
            let pencilImage = UIImage(named: "editPencil.png")
            let imageHeight = UIScreen.scale(20)
            
            let bluePencilImage = pencilImage?.imageWithColor(Constants.COLOR_LRM_ORANGE)
            pencilImageView = UIImageView(image: bluePencilImage)
            pencilImageView.frame = CGRect(x: self.width-LRMRegTextField.pencilPaddingFromRight, y: self.tfdWidthError.y+self.tfdWidthError.textField.height/2-imageHeight/2, width: LRMRegTextField.imageWidth, height:imageHeight)
            self.addSubview(pencilImageView)
            
            self.tfdWidthError.textField.isHidden = true
            self.textEditLabel.text = self.tfdWidthError.textField.text
            self.textEditLabel.isHidden = false
            
        }
        
        //tfdWidthError.textField.removeTarget(self, action: #selector(self.txfeditingDidEnd), for: .editingDidEnd)
        tfdWidthError.textField.addTarget(self, action: #selector(self.txfeditingDidEnd), for: .editingDidEnd)
        
        
    }
    
    
    func setLabelCharSpaceing (inText: String?)
    {
        if let inText = tfdWidthError.textField.text,inText != ""
        {
            let attributedString = NSMutableAttributedString(string: inText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: UIScreen.scale(0.25), range: NSRange(location: 0, length: attributedString.length - 1))
            textEditLabel.attributedText = attributedString
        }
        
    }
    
    
    
    var editing: Editing = .nonEditing
    
    @objc func invBtnPressed()
    {
        
        self.tfdWidthError.textField.becomeFirstResponder()
        textEditLabel.text = self.tfdWidthError.textField.text
        textEditLabel.isHidden = true
        pencilImageView.isHidden = true
        self.tfdWidthError.textField.isHidden = false
        invisibleButtonForTextEdit.isHidden = true
        self.textEditLabel.text = self.tfdWidthError.textField.text
        UIView.animate(withDuration: 0.1, animations: {
            self.tfdWidthError.lblError.y = (self.tfdWidthError.textField.frame.maxY + UIScreen.scale(2))
        })

    }
    
    
    
    func textFieldShouldReturn(_ textField: LRMTextFieldWithError) -> Bool {
        
        if config.isEditField
        {
            textEditLabel.isHidden = false
            pencilImageView.isHidden = false
            self.tfdWidthError.textField.isHidden = true
            invisibleButtonForTextEdit.isHidden=false
            self.textEditLabel.text = self.tfdWidthError.textField.text
            setLabelCharSpaceing(inText: tfdWidthError.textField.text)
            UIView.animate(withDuration: 0.1, animations: {
                self.tfdWidthError.lblError.y = ( self.tfdWidthError.lblError.frame.origin.y - UIScreen.scale(7))
            })
        }
        return false
    }
    

    
    func showError(errorText: String?)
    {
        let different: CGFloat!
        
        tfdWidthError.showError(errorText: errorText)
        
        different = -1 * (self.height - lblUpperText.height - UIScreen.scale(5) - tfdWidthError.height)
        self.height = tfdWidthError.height + lblUpperText.height + UIScreen.scale(5)
        
        delegate?.regTextFieldHeightChanged(self, different: different)
    }
    
    func errorTextFieldHeightChanged(_ tfwithError: LRMTextFieldWithError) {
        let newHeight = tfdWidthError.height
        
        tfdWidthError.height = newHeight
    }
    
    @objc func txfeditingDidEnd()
    {
        _ = textFieldShouldReturn(self.tfdWidthError)
    }
    
    func setDatePickerTo(_ date: Date, animated: Bool){
        tfdWidthError.textField.setDatePickerTo(date, animated: animated)
    }
    
    func getDateFormat() -> (Date){
        return tfdWidthError.textField.datePickerView.date
    }

    
    
    
    
    
}
