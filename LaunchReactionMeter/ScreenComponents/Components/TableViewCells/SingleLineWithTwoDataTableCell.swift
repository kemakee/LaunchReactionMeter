//
//  SingleLineWithTwoDataTableCell.swift
//  LaunchReactionMeter
//
//  Created by Adam Horvath on 2018. 05. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class SingleLineWithTwoDataTableCell: UITableViewCell, ConfigurationProtocol {

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

    private var config: ConfigurationSingleLineWithTwoLabelCell!
    var dataLbl : UILabel!
    var resultLbl : UILabel!
    var separatorView : UIView!

    func configure(_ configuration:ConfigurationComponent) {

        guard configuration is ConfigurationSingleLineWithTwoLabelCell else {
            return
        }

        config = configuration as! ConfigurationSingleLineWithTwoLabelCell

        if dataLbl == nil {
            dataLbl = UILabel(frame: CGRect(x:UIScreen.scale(15), y: 0, width: UIScreen.screenWidth/2+UIScreen.scale(30), height: self.frame.height-UIScreen.scale(2)))
            dataLbl.backgroundColor = Constants.COLOR_LRM_BLACK
            dataLbl.textColor = Constants.COLOR_LRM_ORANGE
            self.contentView.addSubview(dataLbl)
        }
        dataLbl.text = config.dataText

        if resultLbl == nil {
            resultLbl = UILabel(frame: CGRect(x:UIScreen.screenWidth-UIScreen.scale(90), y: 0, width: UIScreen.scale(90), height: self.frame.height-UIScreen.scale(2)))
            resultLbl.backgroundColor = Constants.COLOR_LRM_BLACK
            resultLbl.textColor = Constants.COLOR_LRM_ORANGE
            self.contentView.addSubview(resultLbl)
        }
        resultLbl.text = config.resultText

        if separatorView == nil {
            separatorView = UIView(frame: CGRect(x:UIScreen.scale(7), y: self.height-UIScreen.scale(2), width: UIScreen.screenWidth-UIScreen.scale(14), height: UIScreen.scale(2)))
            separatorView.backgroundColor = Constants.COLOR_LRM_ORANGE
            self.contentView.addSubview(separatorView)
        }

        self.backgroundColor = Constants.COLOR_LRM_BLACK
        self.contentView.backgroundColor = Constants.COLOR_LRM_BLACK


    }

    func reconfigure(_ configuration: ConfigurationComponent) {

        config = configuration as! ConfigurationSingleLineWithTwoLabelCell

        dataLbl.text = config.dataText

        resultLbl.text = config.resultText



    }

    func getConfiguration() -> ConfigurationComponent {
        return config
    }

}
