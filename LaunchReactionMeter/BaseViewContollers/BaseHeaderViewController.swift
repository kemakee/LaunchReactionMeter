//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

enum HeaderNavigationState {
    case none
    case menu
    case back
}

class BaseHeaderViewController: BaseViewController {

    var content: BaseContentViewController?

    var navigationState: HeaderNavigationState = HeaderNavigationState.none

    func setNavigationStateTo(_ state: HeaderNavigationState) {

    }
}
