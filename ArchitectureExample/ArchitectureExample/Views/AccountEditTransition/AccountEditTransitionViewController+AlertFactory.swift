//
//  AccountEditTransitionViewController+AlertFactory.swift
//

import UIKit

extension AccountEditAlertInteractor: InteractorForAlertPresenter {}

extension AccountEditTransitionViewController {
    static func makeAccountEditAlertController(
        lifetimeId: AccountEditAlertLifetimeId,
        alertId: AccountEditAlertId,
        modalPresenter: AccountEditTransitionModalPresenter
    ) -> UIAlertController? {
        guard let lifetime = LifetimeAccessor.accountEditAlert(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        let presenter = AlertPresenter(interactor: lifetime.interactor)

        return makeAlertController(alertPresenter: presenter,
                                   modalSuspender: modalPresenter)
    }
}
