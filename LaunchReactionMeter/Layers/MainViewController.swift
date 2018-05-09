//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//
import UIKit

class MainViewController: UIViewController {

    static var shared = MainViewController()

    private init() {
        super.init(nibName: nil, bundle: nil)
        initLayers()
    }

    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        initLayers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: content viewcontrollers
    var contentContent: BaseContentViewController?
    var headerContent: BaseHeaderViewController?
    var waitingContent: BaseWaitingViewController?
    var toastContent: BaseToastViewController?

    // MARK: layers
    var contentLayer: UIView!
    var headerLayer: UIView!
    var shadeLayer: UIView!
    var modalLayer: UIView!
    var waitingLayer: UIView!
    var toastLayer: UIView!

    private(set) var savedContents: [BaseContentViewController] = [BaseContentViewController]()

    // MARK: statusbar
    func changeStatusbarColor(to: UIColor) {
        let statusbar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusbar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusbar.backgroundColor = to
        }
    }

    // MARK: header
    func load(header newHeader: BaseHeaderViewController) {
        headerLayer.removeSubviews()

        headerContent = newHeader
        headerLayer.addSubview(newHeader.view)
        setHeaderVisibility(toHidden: false)

        connectHeader(to: contentContent)
    }

    func setHeaderVisibility(toHidden isHidden: Bool) {
        let visibilityBefore = headerLayer.isHidden
        headerLayer.isHidden = isHidden

        if visibilityBefore != headerLayer.isHidden && headerContent != nil {
            headerVisibilityChanged()
        }
    }

    func isHeaderVisibile() -> Bool {
        guard headerContent != nil else {
            return false
        }

        return !headerLayer.isHidden
    }

    internal func connectHeader(to content: BaseContentViewController?) {
        guard let header = headerContent else {
            return
        }

        header.content = content
        content?.header = header
    }

    internal func headerVisibilityChanged() {
        updateHeaderLayerFrame()
        updateContentLayerFrame()
    }

    internal func updateHeaderLayerFrame() {
        if let header = headerContent {
            headerLayer.size = header.view.size
        } else {
            headerLayer.size = .zero
        }
    }

    // MARK: content
    func load(content newContent: BaseContentViewController, needHeader: Bool = true, animationEnabled: Bool = true) {
        disableUserInteractions()

        if let actualContent = contentContent {
            actualContent.removeKeyboardObservers()
            actualContent.view.isUserInteractionEnabled = false
        }

        save(content: newContent)
        show(content: newContent, withAnimation: animationEnabled)

        if (needHeader) {
            connectHeader(to: newContent)
            headerContent?.refresh()
        }

        setHeaderVisibility(toHidden: !needHeader)
        newContent.addKeyboardObservers()
        enableUserInteractions()
    }

    func replace(content newContent: BaseContentViewController, needHeader: Bool = true, animationEnabled: Bool = true) {
        load(content: newContent, needHeader: needHeader, animationEnabled: animationEnabled)
        let oldContentIndex = getStackSize() - 2
        let delay = animationEnabled ? Constants.coreAnimationDuration : 0

        let deleteBlock = {
            self.deleteSavedContent(at: oldContentIndex)
            if needHeader {
                self.headerContent?.refresh()
            }
        }

        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                deleteBlock()
            }
        //beacuse of testability
        } else {
            deleteBlock()
        }

    }

    func loadSavedContent(at index: Int, withAnimation animationEnabled: Bool = true) {
        guard isSavedContentExists(at: index) && index != savedContents.count - 1 else {
            print("Not valid index to reload")
            return
        }

        let savedContent = savedContents[index]
        savedContent.beforeRefresh()
        headerContent?.beforeRefresh()

        disableUserInteractions()
        contentContent!.removeKeyboardObservers()

        deleteSavedContent(in: index + 1..<savedContents.count - 1)

        savedContent.addKeyboardObservers()
        if savedContent.header != nil {
            setHeaderVisibility(toHidden: false)
            connectHeader(to: savedContent)
        } else {
            setHeaderVisibility(toHidden: true)
        }

        let deleteContent = contentContent!
        let animationDependencies  = {
            self.deleteSavedContent(deleteContent)
            savedContent.view.isUserInteractionEnabled = true

            savedContent.refreshContent()
            self.headerContent?.refreshContent()

            savedContent.afterRefresh()
            self.headerContent?.afterRefresh()
        }

        if animationEnabled {
            contentContent!.animateOut(completionHandler: { () -> Void in
                animationDependencies()
            })
        } else {
            animationDependencies()
        }

        contentContent = savedContent
        
        self.enableUserInteractions()
    }

    func navigateBack(withAnimation: Bool = true) {
        loadSavedContent(at: getStackSize() - 2, withAnimation: withAnimation)
    }

    func loadFirstScreen() {
        clearSavedContents()
        replace(content: UserChooserViewController(), needHeader: false)
    }

    func clearSavedContents() {
        guard !savedContents.isEmpty else {
            return
        }

        while (1 < getStackSize()) {
            deleteSavedContent(at: 0)
        }
    }

    func getStackSize() -> Int {
        return savedContents.count
    }

    internal func save(content: BaseContentViewController) {
        savedContents.append(content)
    }

    internal func show(content newContent: BaseContentViewController, withAnimation animationEnabled: Bool) {
        contentContent = newContent
        updateContentLayerFrame()
        contentLayer.addSubview(newContent.view)
        
        if animationEnabled {
            disableUserInteractions()
            newContent.view.x = UIScreen.screenWidth
            newContent.animateIn( completionHandler: { () -> Void in
                self.enableUserInteractions()
            })
        }
    }

    internal func updateContentLayerFrame() {
        var newFrameSize = CGSize.zero
        var newOrigin = CGPoint.zero
        let statusbarHeight = UIScreen.statusBarHeight
        let screenHeight = UIScreen.screenHeight
        if isHeaderVisibile() {
            newOrigin = CGPoint(x: contentLayer.x, y: headerLayer.maxY)
            newFrameSize = CGSize(width: contentLayer.width, height: screenHeight - headerContent!.view.maxY - statusbarHeight)
        } else {
            newOrigin = CGPoint(x: contentLayer.x, y: statusbarHeight)
            newFrameSize = CGSize(width: contentLayer.width, height: screenHeight - statusbarHeight)
        }
        contentLayer.frame = CGRect(origin: newOrigin, size: newFrameSize)
        if let content = contentContent {
            content.view.frame = CGRect(origin: CGPoint(x: content.view.x, y: 0), size: contentLayer.size)
            content.svContent.frame = CGRect(origin: CGPoint.zero, size: contentLayer.size)
        }
    }

    internal func deleteSavedContent(in range: Range<Int>) {
        for index in (range.lowerBound..<range.upperBound).reversed() {
            deleteSavedContent(at: index)
        }
    }

    internal func deleteSavedContent(at index: Int) {
        guard isSavedContentExists(at: index) else {
            return
        }
        let deleteContent: BaseContentViewController = savedContents[index]
        deleteSavedContent(deleteContent)
    }

    internal func deleteSavedContent(_ deleteContent: BaseContentViewController) {
        savedContents.removeObject(deleteContent)
        deleteContent.willRemoveFromSuperview()
        deleteContent.interactor?.unregisterPresenter(viewController: deleteContent)
        deleteContent.view.removeFromSuperview()
    }

    internal func isSavedContentExists(at index: Int) -> Bool {
        return savedContents.count > index && index > -1
    }


    
    // MARK: waiting layer
    func load(waiting newWaiting: BaseWaitingViewController) {
        waitingLayer.removeSubviews()

        waitingContent = newWaiting
        waitingLayer.addSubview(newWaiting.view)
        setWaitingVisibility(toHidden: false)
    }

    func setWaitingVisibility(toHidden isHidden: Bool) {
        waitingLayer.isHidden = isHidden
    }

  

   

    // MARK: toast
    func load(toast newToast: BaseToastViewController) {
        toastLayer.removeSubviews()

        toastContent = newToast
        toastLayer.addSubview(newToast.view)
        setToastVisibility(toHidden: false)

        animateUpToastLayer()
    }

    func setToastVisibility(toHidden hidden: Bool) {
        guard toastContent != nil else {
            self.toastLayer.isHidden = hidden
            return
        }
        if hidden {
            animateDownToastLayer()
        } else {
            self.toastLayer.isHidden = hidden
        }
    }

    func load(toastWith message: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.load(toast: SnackbarViewController(text: message))
        })
    }

    internal func animateUpToastLayer() {
        toastLayer.frame = CGRect(origin:CGPoint(x: 0, y: UIScreen.screenHeight), size: toastContent!.view.size)

        UIView.animate(withDuration: Constants.coreAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.toastLayer.y = UIScreen.screenHeight - self.toastContent!.view.height
        }, completion: { (_) in
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(3.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.setToastVisibility(toHidden: true)
            })
        })
    }

    internal func animateDownToastLayer() {
        DispatchQueue.main.async(execute: { () -> Void in
            UIView.animate(withDuration: Constants.coreAnimationDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.toastLayer.y = UIScreen.screenHeight
            }, completion: {(_) -> Void in
                self.toastLayer.isHidden = true
            })
        })
    }

    // MARK: init layers
    internal func initLayers() {
        let screenWidth = UIScreen.screenWidth
        let screenHeight = UIScreen.screenHeight
        let statusBarHeight = UIScreen.statusBarHeight
        let fullScreen = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

        contentLayer = UIView(frame: fullScreen)
        headerLayer = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: screenWidth, height: UIScreen.scale(44)))
        modalLayer = UIView(frame: fullScreen)
        waitingLayer = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: screenWidth, height: screenHeight - statusBarHeight))
        toastLayer = UIView(frame:CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight))

        addLayers()
        setDefaultVisibilities()
    }

    internal func addLayers() {
        self.view.addSubview(contentLayer)
        self.view.addSubview(headerLayer)
        self.view.addSubview(waitingLayer)
        self.view.addSubview(toastLayer)
    }

    internal func setDefaultVisibilities() {
        contentLayer.isHidden = false
        setHeaderVisibility(toHidden: false)
        setWaitingVisibility(toHidden: true)
        setToastVisibility(toHidden: true)
    }

    internal func disableUserInteractions() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    internal func enableUserInteractions() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }

    // MARK: get contentlayerVC methods
    func getContentBeforeContentLayer() -> BaseContentViewController? {
        let indexOfBeforeContent = getIndexOfActualContent() - 1
        if indexOfBeforeContent >= 0 && indexOfBeforeContent < savedContents.count {
            return getViewController(at: indexOfBeforeContent)
        }
        return nil
    }

    func getIndexOfActualContent() -> Int {
        return getViewControllerIndex(inStack: type(of: contentContent!.self) as AnyClass)
    }

    func getViewController(by classType: AnyClass) -> BaseContentViewController? {
        for vc: UIViewController in savedContents {
            if type(of: vc) == classType {
                return vc as? BaseContentViewController
            }
        }
        return nil
    }

    func getViewControllerIndex(inStack classType: AnyClass) -> Int {
        return savedContents.index(where: { type(of: $0) == classType }) ?? -1
    }

    func getViewController(at index: Int) -> BaseContentViewController? {
        guard index >= 0 && index < savedContents.count else {
            return nil
        }

        return savedContents[index]
    }

}
