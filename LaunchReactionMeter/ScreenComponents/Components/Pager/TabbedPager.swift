//
//  TabbedPager.swift
//
//  Created by CodeVision on 2017. 05. 04..
//  Copyright © 2017. CodeVision. All rights reserved.
//

import Foundation
import UIKit

public protocol TabbedPagerDatasource {
    func numberOfViewControllers() -> Int
    func viewController(page: Int) -> UIViewController
    func viewControllerTitle(page: Int) -> String
}

@objc public protocol TabbedPagerDelegate {
    func didShowViewController(page: Int)
}

class TabbedPager: BaseContentViewController {

    public var datasource: TabbedPagerDatasource?
    public weak var delegate: TabbedPagerDelegate?

    var tabHeight: CGFloat!
    private var contentScrollView: UIScrollView!
    private var titleView: UIView!
    private(set) var viewControllers = [UIViewController]()
    private var viewControllerCount: Int = 0
    private var tabButtons = [UIButton]()
    private var bottomLine, tabIndicator: UIView!
    private var selectedIndex: Int = 0
    private var enableParallex = true
    private var isShadowNeeded = false

    init() {
        super.init(nibName: nil, bundle: nil)
        tabHeight = UIScreen.scale(30)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var selectedViewController: UIViewController {
        get {
            return viewControllers[selectedIndex]
        }
        set {

        }
    }
    public var tabColor: UIColor = UIColor.white {
        didSet {
            if bottomLine != nil {
                bottomLine.backgroundColor = tabColor
            }
            if tabIndicator != nil {
                tabIndicator.backgroundColor = tabColor
            }
        }
    }

    public var bottomLineIsHidden: Bool = true {
        didSet {
            bottomLine.isHidden = bottomLineIsHidden
        }
    }

    // MARK: View Controller state restauration
    public override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(selectedIndex, forKey: "selectedIndex")
    }

    public override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        selectedIndex = coder.decodeInteger(forKey: "selectedIndex")
    }

    public override func loadView() {
        super.loadView()

        titleView = UIView(frame: CGRect(x: 0, y: UIScreen.statusBarHeight, width: self.view.width, height: tabHeight))
        titleView.backgroundColor = UIColor.black
        if isShadowNeeded {
            titleView.layer.shadowOpacity = 1
            titleView.layer.shadowOffset = CGSize(width: 0, height: 2)
            titleView.layer.shadowRadius = 4
            titleView.layer.shadowColor = UIColor.blue.cgColor
        }

        self.view.addSubview(titleView)

        bottomLine = UIView(frame: CGRect.zero)
        bottomLine.backgroundColor = tabColor
        bottomLine.isHidden = bottomLineIsHidden
        titleView.addSubview(bottomLine)
        tabIndicator = UIView(frame: CGRect.zero)
        tabIndicator.backgroundColor = tabColor
        titleView.addSubview(tabIndicator)

        contentScrollView = UIScrollView(frame: CGRect(x: 0, y: tabHeight, width: view.width, height: view.height - tabHeight))
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        contentScrollView.backgroundColor = UIColor.black
        contentScrollView.delaysContentTouches = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.isScrollEnabled = true
        contentScrollView.delegate = self
        self.view.addSubview(contentScrollView)

        self.view.bringSubview(toFront: titleView)
    }

    override func initLayout() {
        super.initLayout()
        self.svContent.removeFromSuperview()
    }

    override func refreshContent() {
        super.refreshContent()
        for viewController in self.viewControllers {
            if let vc = viewController as? BaseContentViewController {
                vc.refreshContent()
            }
        }
    }

    var layoutSubviewsHappend = false

    public override func viewWillLayoutSubviews() {
        if !layoutSubviewsHappend {
            layoutSubviewsHappend = true
            self.reloadData()
            self.layout()
        }
    }

    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if titleView != nil {
            contentScrollView.delegate = nil
            coordinator.animate(alongsideTransition: nil, completion: {_ -> Void in
                self.contentScrollView.delegate = self
                self.switchPage(index: self.selectedIndex, animated: false)
            })
        }
    }

    // MARK: Public methods
    public func reloadData() {
        for vc in viewControllers {
            vc.willMove(toParentViewController: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
        viewControllers.removeAll(keepingCapacity: true)

        if let cc = datasource?.numberOfViewControllers() {
            self.viewControllerCount = cc
            for i in 0..<viewControllerCount {
                let vc = datasource!.viewController(page: i)
                viewControllers.append(vc)

                addChildViewController(vc)
                let size = contentScrollView.frame.size
                vc.view.frame = CGRect(x:size.width * CGFloat(i), y:0, width:size.width, height:size.height)
                contentScrollView.addSubview(vc.view)
                vc.didMove(toParentViewController: self)

            }
            generateTabs()
            layout()

            selectedIndex = min(viewControllerCount-1, selectedIndex)
            if selectedIndex > 0 {// Happens for example in case of a restore
                switchPage(index: selectedIndex, animated: false)
            }
        }
    }

    public func switchPage(index: Int, animated: Bool) {
        let posX = contentScrollView.width * CGFloat(index)
        let frame = CGRect(x: posX, y: 0, width: contentScrollView.width, height: contentScrollView.height)
        if frame.origin.x < contentScrollView.contentSize.width {

            enableParallex = !animated
            contentScrollView.scrollRectToVisible(frame, animated: animated)
        }
    }

    // MARK: Helpers methods
    /// Generate the fitting UILabel's
    private func generateTabs() {
        for label in self.tabButtons {
            label.removeFromSuperview()
        }
        self.tabButtons.removeAll(keepingCapacity: true)

        let buttonWidth = self.view.width / CGFloat(viewControllers.count)
        var currentX: CGFloat = 0
        for i in 0..<self.viewControllerCount {
            let button = UIButton(type: .custom)
            button.setTitle(self.datasource?.viewControllerTitle(page: i), for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            button.frame = CGRect(x: currentX, y: 0, width: buttonWidth, height: tabHeight)
            currentX += buttonWidth

            button.addTarget(self, action: #selector(TabbedPager.receivedButtonTab(sender:)), for: .touchUpInside)
            self.tabButtons.append(button)
            self.titleView.addSubview(button)
        }
    }

    /// Action method to move the pager in the right direction
    @objc public func receivedButtonTab(sender: UIButton) {
        if let i = tabButtons.index(of: sender) {
            switchPage(index: i, animated:true)
        }
    }

    private func layout() {
        var size = self.view.bounds.size
        titleView.frame = CGRect(x:0, y:0, width:size.width, height:tabHeight)
        contentScrollView.frame = CGRect(x:0, y:tabHeight, width:self.view.bounds.size.width, height:self.view.bounds.size.height - tabHeight)

        size = contentScrollView.frame.size
        for i in 0..<self.viewControllerCount {
            let vc = viewControllers[i]
            vc.view.frame = CGRect(x: size.width * CGFloat(i), y: 0.0, width: size.width, height: size.height)
        }

        contentScrollView.contentSize = CGSize(width:size.width * CGFloat(viewControllerCount), height:size.height)
        bottomLine.frame = CGRect(x:0, y:tabHeight-UIScreen.scale(1), width:titleView.width, height:UIScreen.scale(1))
        layoutTabIndicator()
    }

    /// Repositions the indication marker below the tab
    func layoutTabIndicator() {
        let label = tabButtons[selectedIndex]
        tabIndicator.frame = CGRect(x: label.x, y: label.height-UIScreen.scale(2), width: label.width, height: UIScreen.scale(2))

        var i = 0
        for button in tabButtons {
            let selectedFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize+UIScreen.scale(2))
            button.titleLabel?.font = i == selectedIndex ? selectedFont : UIFont.systemFont(ofSize: UIFont.systemFontSize)
            i += 1
        }
    }

    // MARK: UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            let pageWidth = scrollView.frame.size.width
            let page = (scrollView.contentOffset.x - pageWidth / 2) / pageWidth + 1
            var next = Int(floor(page))
            if next < 0 {
                next = 0
            } else if next > viewControllers.count - 1 {
                next = viewControllers.count - 1
            }

            if next != selectedIndex {
                selectedIndex = next
                UIView.animate(withDuration: enableParallex ? 0.3: 0, animations:layoutTabIndicator, completion: {_ in
                                self.delegate?.didShowViewController(page: self.selectedIndex)
                                if let vc = self.viewControllers[self.selectedIndex] as? BaseContentViewController {
                                    vc.refreshContent()
                                }
                })
            }
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            enableParallex = true
        }
    }
}
