//
//  SegmentedControl.swift
//  ComeGetIt
//
//  Created by Ákos Kemenes on 2017. 07. 03..
//  Copyright © 2017. ComeGetIt. All rights reserved.
//

import UIKit

protocol SegmentedControlDelegate: NSObjectProtocol {
    func SegmentedControlWichPressed(_ segmentedControl: SegmentedControl, whichPressed: Int)
}


class SegmentedControl: UIView{

    weak var delegate: SegmentedControlDelegate?

    required init(configuration: ConfigurationComponent) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height:10))
        self.configure(configuration)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var LRMSegControl: UISegmentedControl!
    
    
    func configure(_ configuration: ConfigurationComponent) {
        
        guard configuration is ConfigurationSegmentedControl else {
            return
        }
        
        let scBackViewHeight = UIScreen.scale(50)
        
        
        let config = configuration as! ConfigurationSegmentedControl
        
        
        self.frame = CGRect(x: 0, y: config.y, width: UIScreen.screenWidth, height: scBackViewHeight)

        
        let scBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: scBackViewHeight))
        scBackView.backgroundColor = Constants.COLOR_LRM_BLACK
        self.addSubview(scBackView)
        
        
        LRMSegControl = UISegmentedControl(items: config.titles)
        LRMSegControl.selectedSegmentIndex = 0
        
        let scHeight = UIScreen.scale(29)
        LRMSegControl.frame = CGRect(x: UIScreen.scale(13), y: scBackView.height/2-scHeight/2, width: UIScreen.screenWidth - 2*UIScreen.scale(13), height: scHeight)
        LRMSegControl.layer.cornerRadius = 5.0
        LRMSegControl.backgroundColor = UIColor.clear
        LRMSegControl.tintColor = UIColor.clear
        
        let attr_normal: [AnyHashable: Any] = [
            NSAttributedStringKey.foregroundColor: Constants.COLOR_LRM_WHITE_40,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        LRMSegControl.setTitleTextAttributes(attr_normal, for: .normal)
        let attr_selected: [AnyHashable: Any] = [
            NSAttributedStringKey.foregroundColor: Constants.COLOR_LRM_WHITE,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize+UIScreen.scale(2))
        ]
        LRMSegControl.setTitleTextAttributes(attr_selected, for: .selected)

        LRMSegControl.addTarget(self, action:#selector(self.changeViews), for: .valueChanged)
            
        // Add this custom Segmented Control to our view
        scBackView.addSubview(LRMSegControl)
    }
    
    @objc func changeViews()
    {
        delegate?.SegmentedControlWichPressed(self, whichPressed: LRMSegControl.selectedSegmentIndex)
        
    }

}
