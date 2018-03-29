//
//  BaseContentViewController.swift
//	AppCore
//
//  Created by CodeVision on 14/05/17.
//  Copyright (c) 2017 All rights reserved.
//

import UIKit
import Foundation

class BaseContentViewController: BaseViewController, MovementProtocol, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var header: BaseHeaderViewController?
    private(set) var svContent: UIScrollView = UIScrollView()
    var contentHeight: CGFloat = 0
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var tapGestureRecognizer: UITapGestureRecognizer!

    var interactor: BaseInteractorProtocol!

    func drag(delta: CGFloat, completionHandler: (() -> Void)?) {
        let newX = max(0, view.x + delta)
        view.x = newX
        completionHandler?()
    }

    func animateIn(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: Constants.coreAnimationDuration, animations: {
            self.view.x = 0
        }, completion: { _ in
            completionHandler?()
        })
    }

    func animateOut(completionHandler: (() -> Void)?) {
        UIView.animate(withDuration: Constants.coreAnimationDuration, animations: {
            self.view.x = UIScreen.screenWidth
        }, completion: { _ in
            completionHandler?()
        })
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            let sensitiveFrame = CGRect(origin: .zero, size: CGSize(width: UIScreen.scale(10), height:view.height))
            let location = touch.location(in: view)
            return sensitiveFrame.contains(location)
        }
        return true
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        addGestureRecognizers()

        svContent.scrollsToTop = true
        svContent.alwaysBounceVertical = true
        svContent.clipsToBounds = true
        view.addSubview(svContent)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    func addGestureRecognizers() {
        let selector = #selector(MainViewController.shared.processPanGesture(_:))
        panGestureRecognizer = UIPanGestureRecognizer(target: MainViewController.shared, action: selector)
        panGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(panGestureRecognizer)

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func afterLoad() {
        super.afterLoad()
        self.sendGAScreenTracking()
    }

    override func afterRefresh() {
        super.afterRefresh()
        self.sendGAScreenTracking()
    }

    func setContentHeight(_ contentHeight: CGFloat, withBounce bounces: Bool = true) {
        self.contentHeight = contentHeight
        let height = max(self.view.height, self.contentHeight)
        svContent.bounces = bounces
        self.svContent.contentSize.height = height
    }

    func overrideHeaderBackButtonPressed() {
        MainViewController.shared.navigateBack()
    }

    // MARK: keyboard handling
    var keyboardFrameBeginRect: CGRect = .zero
    var keyboardAnimationDuration: Double = 0.0
    var currentResponder: UIView = UITextField()
    var textFieldsArray: [UIView] = [UIView]()

    internal func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    internal func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        let keyboardWillShowSelector = #selector(BaseContentViewController.keyboardWillShow(_:))
        let keyboardWillHideSelector = #selector(BaseContentViewController.keyboardWillHide(_:))
        let keyboardFrameWillChangeSelector = #selector(BaseContentViewController.keyboardFrameWillChange(_:))
        notificationCenter.addObserver(self, selector: keyboardWillShowSelector, name: .UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: keyboardWillHideSelector, name: .UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: keyboardFrameWillChangeSelector, name: .UIKeyboardWillChangeFrame, object: nil)
    }

    fileprivate func setKeyboardProperties(_ note: Notification) {
        let keyboardInfo = note.userInfo!
        keyboardFrameBeginRect = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        keyboardAnimationDuration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
    }

    @objc func keyboardWillShow(_ note: Notification) {
        setKeyboardProperties(note)

        for textfield in self.textFieldsArray {
            if( (textfield is UITextField) && (textfield as! UITextField).isEditing) || textfield is UITextView {
                self.currentResponder = textfield
                break
            }
        }

        moveUpContent()
    }

    @objc func keyboardWillHide(_ note: Notification) {
        svContent.height = self.view.height
    }

    @objc func keyboardFrameWillChange(_ note: Notification) {
        setKeyboardProperties(note)
        moveUpContent()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return stepToNextTextfield(textField)
    }

    func moveUpContent() {
        guard !self.textFieldsArray.isEmpty else {
            return
        }

        let currentResponderActualFrame = svContent.convert(currentResponder.frame, from: svContent)

        UIView.animate(withDuration: keyboardAnimationDuration, animations: { () -> Void in
            let visibleContentHeight = self.view.height - self.keyboardFrameBeginRect.size.height
            self.svContent.height = visibleContentHeight
            let padding = UIScreen.scale(80)

            if currentResponderActualFrame.maxY > visibleContentHeight - padding {
                let bottomOffsetY = self.svContent.contentSize.height - visibleContentHeight
                let contentOffsetY = bottomOffsetY - max(visibleContentHeight - currentResponderActualFrame.origin.y, 0)
                self.svContent.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: false)
            }

        }, completion: nil)

    }

    func stepToNextTextfield(_ textField: UITextField) -> Bool {
        var positionOfTextfield: Int = -1
        var index: Int = 0
        for iteratortxtField: UIView in textFieldsArray {
            if textField == iteratortxtField {
                positionOfTextfield = index
                currentResponder = textField
                break
            }
            index += 1
        }
        if positionOfTextfield == self.textFieldsArray.count - 1 {
            textField.resignFirstResponder()
            doMethodAfterLastTextField()
        } else {
            let txfNext = textFieldsArray[positionOfTextfield + 1]
            txfNext.becomeFirstResponder()

            currentResponder = txfNext
            self.moveUpContent()
        }

        return currentResponder is UITextField
    }

    func doMethodAfterLastTextField() {

    }

    func sendGAScreenTracking() {
        guard !(self is TabbedPager) else {
            return
        }

    }

    func showSnackbar(with message: String = "MainVC.SomeThingWrong".localized) {
        MainViewController.shared.load(toastWith: message)
    }

    func showLoader() {
        MainViewController.shared.loadFullScreenWaiting()
    }

    func hideLoader() {
        MainViewController.shared.setWaitingVisibility(toHidden: true)
    }

    @objc func dismissKeyboard() {
        svContent.endEditing(true)
    }

}
