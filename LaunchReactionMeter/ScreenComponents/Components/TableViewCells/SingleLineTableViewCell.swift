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
    
    func configure(_ configuration:ConfigurationComponent) {
        
        guard configuration is ConfigurationSingeLineTableViewCell else {
            return
        }
        
        config = configuration as! ConfigurationSingeLineTableViewCell
        
        if nameLbl == nil {
            nameLbl = UILabel(frame: CGRect(x:0, y: 0, width: self.frame.width, height: self.frame.height))
            nameLbl.backgroundColor = UIColor.lightGray
            nameLbl.textColor = UIColor.red
            self.contentView.addSubview(nameLbl)
        }
        nameLbl.text = config.deviceName
        
    }
    
    func reconfigure(_ configuration: ConfigurationComponent) {
        
    }
    
    func getConfiguration() -> ConfigurationComponent {
        return config
    }

    
}


