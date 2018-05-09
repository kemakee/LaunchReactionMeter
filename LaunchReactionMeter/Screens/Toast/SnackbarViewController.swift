//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit
import Foundation

class SnackbarViewController: BaseToastViewController {
    var snackbarText: String
    var message: Label!

    init(text: String) {
        snackbarText = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initLayout() {
        self.view.autoresizingMask = UIViewAutoresizing()

        self.view.backgroundColor = Constants.COLOR_LRM_ORANGE
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let padding = UIScreen.scale(20)
        let lblMessageConfig = ConfigurationLabel(size: CGSize(width: UIScreen.screenWidth - 2 * padding, height: UIScreen.scale(50)), text: snackbarText)
        lblMessageConfig.textColor = .white

        message = Label(configuration: lblMessageConfig)
        message.textAlignment = .center
        message.frame.origin = CGPoint(x: 0, y :0 )
        self.view.frame.origin = CGPoint(x: 0, y: UIScreen.screenHeight-message.height)
        self.view.height = message.y + message.height + UIScreen.scale(15)

        self.view.addSubview(message)

        
    
    }
    

}

