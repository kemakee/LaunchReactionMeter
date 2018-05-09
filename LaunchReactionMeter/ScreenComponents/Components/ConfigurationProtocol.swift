//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import Foundation

protocol ConfigurationProtocol {

    init(configuration: ConfigurationComponent)

    func configure(_ configuration: ConfigurationComponent)

    func reconfigure(_ configuration: ConfigurationComponent)

    func getConfiguration() -> ConfigurationComponent
}
