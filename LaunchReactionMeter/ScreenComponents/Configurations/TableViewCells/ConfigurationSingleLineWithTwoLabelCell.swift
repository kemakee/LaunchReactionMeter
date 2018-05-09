//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class ConfigurationSingleLineWithTwoLabelCell: ConfigurationComponent {
    var dataText : String!
    var resultText : String!

    init(dataText: String, resultText: String) {
        super.init()
        self.dataText = dataText
        self.resultText = resultText
    }
}
