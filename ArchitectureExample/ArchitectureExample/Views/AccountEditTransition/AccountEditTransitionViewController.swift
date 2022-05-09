//
//  AccountEditTransitionViewController.swift
//

import UIKit
import Combine

final class AccountEditTransitionViewController: UIViewController {
    let presenter: AccountEditTransitionPresenter
    let modalPresenter: AccountEditTransitionModalPresenter
    private var cancellables: Set<AnyCancellable> = .init()

    init(presenter: AccountEditTransitionPresenter,
         modalPresenter: AccountEditTransitionModalPresenter) {
        self.presenter = presenter
        self.modalPresenter = modalPresenter

        super.init(nibName: nil, bundle: nil)

        self.presentationController?.delegate = self

        presenter.$isModalInPresentation
            .sink { [weak self] isModal in
                self?.isModalInPresentation = isModal
            }
            .store(in: &self.cancellables)

        modalPresenter.$modal
            .removeDuplicates()
            .sink { [weak self] modal in
                switch modal {
                case .alert(let lifetimeId, let alertId):
                    self?.presentAlert(lifetimeId: lifetimeId,
                                       alertId: alertId)
                case .none:
                    self?.dismissModal()
                }
            }
            .store(in: &self.cancellables)

        if let child = Self.makeAccountEditHostingController(accountEditLifetimeId: presenter.accountEditLifetimeId) {
            self.presentChild(child, duration: 0.0)
        } else {
            assertionFailure()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountEditTransitionViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.presenter.viewDidDismiss()
    }
}
