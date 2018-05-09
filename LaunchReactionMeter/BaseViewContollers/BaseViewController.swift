//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, LifeCycleDelegate, RefreshProtocol {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.afterInstantiation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.beforeLoad()

        super.loadView()

        self.initLayout()

        self.afterLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
  
    }

    deinit {
        self.beforeDeallocation()
    }

    func refresh() {
        self.beforeRefresh()

        self.refreshContent()

        self.afterRefresh()
    }

    // MARK: methods to be overridden
    // the VC loaded for the first time - here you can build up the content
    func initLayout() {
    }

    func refreshContent() {
    }

    // MARK: conform to LifeCycleDelegate
    func afterInstantiation() {

    }

    func beforeLoad() {

    }

    func afterLoad() {

    }

    func beforeRefresh() {

    }

    func afterRefresh() {

    }

    func willRemoveFromSuperview() {

    }

    func beforeDeallocation() {

    }
}
