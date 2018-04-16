//
//  SingleLineTableViewCell.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 03. 07..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class SingleLineTableViewCell: UITableViewCell, ConfigurationProtocol {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init(configuration: ConfigurationComponent) {
        
        super.init(style: .default, reuseIdentifier: "cellIdentifier")
        
        self.configure(configuration)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var config: ConfigurationSingeLineTableViewCell!
    var nameLbl : UILabel!
    var separatorView : UIView!
    
    func configure(_ configuration:ConfigurationComponent) {
        
        guard configuration is ConfigurationSingeLineTableViewCell else {
            return
        }
        
        config = configuration as! ConfigurationSingeLineTableViewCell
        
        if nameLbl == nil {
            nameLbl = UILabel(frame: CGRect(x:UIScreen.scale(8), y: 0, width: self.frame.width, height: self.frame.height))
            nameLbl.backgroundColor = Constants.COLOR_LRM_BLACK
            nameLbl.textColor = Constants.COLOR_LRM_ORANGE
            self.contentView.addSubview(nameLbl)
        }
        nameLbl.text = config.deviceName
        
        if separatorView == nil {
            separatorView = UIView(frame: CGRect(x:UIScreen.scale(7), y: self.height-UIScreen.scale(2), width: self.frame.width-UIScreen.scale(14), height: UIScreen.scale(2)))
            separatorView.backgroundColor = Constants.COLOR_LRM_ORANGE
            self.contentView.addSubview(separatorView)
        }
        
        
        
        self.contentView.backgroundColor = config.backColor
        
    }
    
    func reconfigure(_ configuration: ConfigurationComponent) {
        
        config = configuration as! ConfigurationSingeLineTableViewCell
        
      
        nameLbl = UILabel(frame: CGRect(x:UIScreen.scale(8), y: 0, width: self.frame.width, height: self.frame.height))
        nameLbl.backgroundColor = Constants.COLOR_LRM_BLACK
        nameLbl.textColor = Constants.COLOR_LRM_ORANGE
        self.contentView.addSubview(nameLbl)
        
        nameLbl.text = config.deviceName

        separatorView = UIView(frame: CGRect(x:UIScreen.scale(7), y: self.height-UIScreen.scale(2), width: self.frame.width-UIScreen.scale(14), height: UIScreen.scale(2)))
        separatorView.backgroundColor = Constants.COLOR_LRM_ORANGE
        self.contentView.addSubview(separatorView)
      
        self.contentView.backgroundColor = config.backColor
        
        
    }
    
    func getConfiguration() -> ConfigurationComponent {
        return config
    }

    
}


