//
//  RootTransitionViewController.swift
//

import UIKit
import Combine

final class RootTransitionViewController: UIViewController {
    private(set) var childPresenter: RootTransitionChildPresenter?
    private(set) var modalPresenter: RootTransitionModalPresenter?
    private(set) var commandPresenter: RootCommandPresenter?
    private var cancellables: Set<AnyCancellable> = .init()

    func setup(childPresenter: RootTransitionChildPresenter,
               modalPresenter: RootTransitionModalPresenter,
               commandPresenter: RootCommandPresenter) {
        self.childPresenter = childPresenter
        self.modalPresenter = modalPresenter
        self.commandPresenter = commandPresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let childPresenter = self.childPresenter,
              let modalPresenter = self.modalPresenter else {
            assertionFailureIfNotTest()
            return
        }

        childPresenter.$child
            .removeDuplicates()
            .sink { [weak self] child in
                guard let self = self else { return }

                switch child {
                case .login(let sceneLifetimeId):
                    self.replaceChild(Self.makeLoginHostingController(sceneId: sceneLifetimeId))
                case .account(let lifetimeId):
                    self.replaceChild(
                        Self.makeAccountNavigationController(accountLifetimeId: lifetimeId))
                case .none:
                    self.replaceChild(nil)
                }
            }.store(in: &self.cancellables)

        modalPresenter.$modal
            .removeDuplicates()
            .sink { [weak self] modal in
                switch modal {
                case .alert(let lifetimeId):
                    self?.presentAlert(lifetimeId: lifetimeId)
                case .accountEdit(let lifetimeId):
                    self?.presentAccountEdit(lifetimeId: lifetimeId)
                case .none:
                    self?.dismissModal()
                }
            }.store(in: &self.cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.childPresenter?.viewDidAppear()
    }
}
