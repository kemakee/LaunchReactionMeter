//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import Foundation

@objc protocol LifeCycleDelegate {
    @objc optional func afterInstantiation()

    @objc optional func beforeLoad()

    @objc optional func afterLoad()

    @objc optional func beforeRefresh()

    @objc optional func afterRefresh()

    @objc optional func willRemoveFromSuperview()

    @objc optional func beforeDeallocation()

}
