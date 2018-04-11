
import UIKit
import SnapKit

class UserChooserViewController: BaseContentViewController {

    var coachButton : LRMButton!
    var athleteButton : LRMButton!
    var registrationButton : LRMButton!

    
    let padding = UIScreen.scale(30)
    var logoIV : UIImageView!
    var loginInteractor: LoginInteractorProtocol {
        
        return interactor as! LoginInteractorProtocol
    }

    init()
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func initLayout() {
        super.initLayout()
        self.svContent.isScrollEnabled = false
        self.svContent.backgroundColor = Constants.COLOR_LRM_BLACK

        
        LoginConfigurator.configureUserChooserViewControler(viewController: self)
        
        let logoImage = UIImage(named: "logo.png")
        logoIV = UIImageView(image: logoImage)
        logoIV.size = CGSize(width: UIScreen.screenWidth*0.75, height: UIScreen.screenHeight/8)
        self.svContent.addSubview(logoIV)
        
        let configAthBtn : ConfigurationLRMButton = ConfigurationLRMButton(y: 0, text: "Athlete", color: .orange, size: .normal)
        athleteButton = LRMButton(configuration: configAthBtn)
        self.svContent.addSubview(athleteButton)
        athleteButton.addTarget(self, action: #selector(athletePressed), for: .touchUpInside)

        
        
        let configCoachBtn : ConfigurationLRMButton = ConfigurationLRMButton(y: 0, text: "Coach", color: .orange, size: .normal)
        coachButton = LRMButton(configuration: configCoachBtn)
        self.svContent.addSubview(coachButton)
        coachButton.addTarget(self, action: #selector(coachPressed), for: .touchUpInside)

        
        let configRegBtn : ConfigurationLRMButton = ConfigurationLRMButton(y: 0, text: "Registration", color: .white, size: .normal)
        registrationButton = LRMButton(configuration: configRegBtn)
        self.svContent.addSubview(registrationButton)
        registrationButton.addTarget(self, action: #selector(regPressed), for: .touchUpInside)
        
        
        self.view.setNeedsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        logoIV.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0).offset(padding*3)
            make.left.equalTo(UIScreen.screenWidth/2-logoIV.width/2)
            make.width.equalTo(logoIV.width)
            make.height.equalTo(logoIV.height)
        }
        
        athleteButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(UIScreen.screenHeight/2-athleteButton.height)
            make.left.equalTo(UIScreen.screenWidth/2-athleteButton.width/2)
            make.width.equalTo(athleteButton.width)
            make.height.equalTo(athleteButton.height)
        }
        
        coachButton.snp.makeConstraints { (make) in
            make.top.equalTo(athleteButton.snp.bottom).offset(padding)
            make.left.equalTo((UIScreen.screenWidth/2-coachButton.width/2))
            make.width.equalTo(coachButton.width)
            make.height.equalTo(coachButton.height)
        }
        
        registrationButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(UIScreen.screenHeight*0.85)
            make.left.equalTo((UIScreen.screenWidth/2-registrationButton.width/2))
            make.width.equalTo(registrationButton.width)
            make.height.equalTo(registrationButton.height)
        }
 
        
    }
    
    @objc func regPressed()
    {
        loginInteractor.navigateToRegistrationScreen()
    }
    
    @objc func athletePressed()
    {
        loginInteractor.navigateToLogin()
    }
    
    @objc func coachPressed()
    {
        loginInteractor.navigateToLogin()
    }
    
   
    
}

