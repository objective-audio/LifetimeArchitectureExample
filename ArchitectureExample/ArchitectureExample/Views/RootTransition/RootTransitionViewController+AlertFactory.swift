//
//  RootTransitionViewController+AlertFactory.swift
//

import UIKit

extension RootAlertInteractor: AlertPresenter.Interactor {}

extension RootTransitionViewController {
    static func makeRootAlertController(lifetimeId: RootAlertLifetimeId,
                                        modalPresenter: RootTransitionModalPresenter) -> UIAlertController? {
        guard let lifetime = LifetimeAccessor.rootAlert(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        let presenter = AlertPresenter(interactor: lifetime.interactor)

        return makeAlertController(alertPresenter: presenter,
                                   modalSuspender: modalPresenter)
    }
}
