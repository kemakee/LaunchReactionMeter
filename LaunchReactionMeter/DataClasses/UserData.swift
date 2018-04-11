//
//  RegistrationData.swift
//  LaunchReactionMeter
//
//  Created by Ákos Kemenes on 2018. 04. 08..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class UserData: NSObject {
    var password : String?
    var email : String?
    
    init(password: String, email: String) {
        self.password = password
        self.email = email
        super.init()
    }

}
