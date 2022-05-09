//
//  RootTransitionViewController+Modal.swift
//

import UIKit

extension RootTransitionViewController: ModalPresentableViewController {
    var modalSuspender: ModalSuspendable { self.modalPresenter! }
}

extension RootTransitionViewController {
    func presentAlert(lifetimeId: RootAlertLifetimeId) {
        guard self.presentedViewController == nil,
              let modalPresenter = self.modalPresenter,
              let alert = Self.makeRootAlertController(lifetimeId: lifetimeId,
                                                       modalPresenter: modalPresenter) else {
            assertionFailure()
            return
        }

        self.presentModal(alert)
    }

    func presentAccountEdit(lifetimeId: AccountEditLifetimeId) {
        guard let presenting =
                Self.makeAccountEditTransitionViewController(accountEditLifetimeId: lifetimeId) else {
            assertionFailure()
            return
        }

        self.presentModal(presenting)
    }
}
