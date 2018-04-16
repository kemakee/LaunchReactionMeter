
import UIKit

class LRMButton: UIButton, ConfigurationProtocol {
    
    private var config : ConfigurationLRMButton!
    
    func reconfigure(_ configuration: ConfigurationComponent) {
        
        guard configuration is ConfigurationLRMButton else {
            return
        }
        
        config = configuration as! ConfigurationLRMButton
        switch config.size {
        case .custom:
            self.frame = config.frame!
        case .normal:
            self.frame = CGRect(x: UIScreen.scale(12), y: config.y, width: UIScreen.screenWidth-UIScreen.scale(24), height: UIScreen.scale(32))
        default: ()
        }
        self.setTitle(config.text, for: .normal)
        self.titleLabel?.font = Constants.LRM_TYPO_18
        
        switch config.color {
        case .orange:
            self.backgroundColor = Constants.COLOR_LRM_ORANGE
            self.setTitleColor(Constants.COLOR_LRM_BLACK, for: .normal)
            self.layer.cornerRadius = UIScreen.scale(5)
        case .gray:
            self.backgroundColor = UIColor.clear
            self.setTitleColor(Constants.COLOR_LRM_TEXT_GRAY_LIGHTER, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.scale(UIFont.buttonFontSize-3) )
        case .white:
            self.backgroundColor = UIColor.clear
            self.setTitleColor(Constants.COLOR_LRM_WHITE, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.scale(UIFont.buttonFontSize-2) )
            
            
            
        }
        
    }
    
  

    required init(configuration: ConfigurationComponent) {
        super.init(frame: CGRect(x: UIScreen.scale(12), y: 0, width: UIScreen.screenWidth-UIScreen.scale(24), height:UIScreen.scale(20)))
        self.configure(configuration)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure(_ configuration: ConfigurationComponent) {

        guard configuration is ConfigurationLRMButton else {
            return
        }
        
        config = configuration as! ConfigurationLRMButton
        switch config.size {
        case .custom:
            self.frame = config.frame!
        case .normal:
            self.frame = CGRect(x: UIScreen.scale(12), y: config.y, width: UIScreen.screenWidth-UIScreen.scale(24), height: UIScreen.scale(32))
        default: ()
        }
        self.setTitle(config.text, for: .normal)
        self.titleLabel?.font = Constants.LRM_TYPO_18
        
        switch config.color {
        case .orange:
            self.backgroundColor = Constants.COLOR_LRM_ORANGE
            self.setTitleColor(Constants.COLOR_LRM_BLACK, for: .normal)
            self.layer.cornerRadius = UIScreen.scale(5)
        case .gray:
            self.backgroundColor = UIColor.clear
            self.setTitleColor(Constants.COLOR_LRM_TEXT_GRAY_LIGHTER, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.scale(UIFont.buttonFontSize-3) )
        case .white:
            self.backgroundColor = UIColor.clear
            self.setTitleColor(Constants.COLOR_LRM_WHITE, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.scale(UIFont.buttonFontSize-2) )

            
    
        }
        
    
    }
    func getConfiguration() -> ConfigurationComponent {
        return config
    }
    

}
