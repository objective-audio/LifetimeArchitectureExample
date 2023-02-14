//
//  RootTransitionViewController.swift
//

import UIKit
import Combine

final class RootTransitionViewController: UIViewController {
    private(set) var commandPresenter: RootCommandPresenter?

    func setup(childPresenter: RootChildPresenter,
               modalPresenter: RootModalPresenter,
               commandPresenter: RootCommandPresenter) {
        self.commandPresenter = commandPresenter

        self.presentChild(RootTransitionHostingController(childPresenter: childPresenter,
                                                          modalPresenter: modalPresenter),
                          duration: 0.0)
    }
}
