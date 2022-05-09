//
//  AccountEditTransitionViewController+Modal.swift
//

import UIKit

extension AccountEditTransitionViewController: ModalPresentableViewController {
    var modalSuspender: ModalSuspendable { self.modalPresenter }
}

extension AccountEditTransitionViewController {
    func presentAlert(lifetimeId: AccountEditAlertLifetimeId,
                      alertId: AccountEditAlertId) {
        guard let alert = Self.makeAccountEditAlertController(lifetimeId: lifetimeId,
                                                              alertId: alertId,
                                                              modalPresenter: self.modalPresenter) else {
            assertionFailure()
            return
        }

        self.presentModal(alert)
    }
}
