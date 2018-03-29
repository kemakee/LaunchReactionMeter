//
//  BaseInteractor.swift
//
//  Created by CodeVision on 2017. 04. 13..
//  Copyright © 2017. All rights reserved.
//

import UIKit

enum InteractorException: Error {
    case presenterNotFound
}

@objc protocol BaseInteractorProtocol: class {
    func registerPresenter(_ presenter: BasePresenterProtocol)
    func unregisterPresenter(viewController: BaseContentViewController)
}

class BaseInteractor: NSObject, BaseInteractorProtocol {

    var presenterContainer: [BasePresenterProtocol] = []

    // MARK: base methods
    func getPresenter(byClassType classType: AnyClass, at index: Int = 0) throws -> BasePresenterProtocol! {
        var i = 0

        for presenterItem in presenterContainer {
            if type(of: presenterItem) == classType {
                if index == i {
                    return presenterItem
                } else {
                    i += 1
                }
            }
        }

        throw InteractorException.presenterNotFound

    }

    func getLastPresenter(byProtocol ownprotocol: Protocol) throws -> BasePresenterProtocol! {
        var presenterItem: BasePresenter

        guard !presenterContainer.isEmpty else {
            throw InteractorException.presenterNotFound
        }

        for index in (0...presenterContainer.count - 1).reversed() {
            presenterItem = presenterContainer[index] as! BasePresenter

            if presenterItem.conforms(to: ownprotocol) {
                return presenterItem
            }
        }

        throw InteractorException.presenterNotFound

    }

    // MARK: conform to BaseInteractorProtocol
    func registerPresenter(_ presenter: BasePresenterProtocol) {
        if !presenterContainer.contains(where: { (value) -> Bool in
                value === presenter
            }) {
            presenterContainer.append(presenter)
        }
    }

    func unregisterPresenter(viewController: BaseContentViewController) {
        for i in 0...presenterContainer.count {
            if let presenter = presenterContainer[i] as? BasePresenter, presenter.viewController == viewController {
                presenterContainer.remove(at: i)
                break
            }
        }
    }

}
