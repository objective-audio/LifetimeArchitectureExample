//
//  RootTransitionViewController.swift
//

import UIKit
import Combine

final class RootTransitionViewController: UIViewController {
    private(set) var commandPresenter: RootCommandPresenter?

    func setup(childPresenter: RootTransitionChildPresenter,
               modalPresenter: RootTransitionModalPresenter,
               commandPresenter: RootCommandPresenter) {
        self.commandPresenter = commandPresenter

        self.presentChild(RootTransitionHostingController(presenter: childPresenter,
                                                          modalPresenter: modalPresenter,
                                                          commandPresenter: commandPresenter),
                          duration: 0.0)
    }
}
