//
//  AccountEditAlertPresenter.swift
//

import Foundation

@MainActor
final class AccountEditAlertPresenter {
    private weak var interactor: AccountEditAlertInteractor?

    init(interactor: AccountEditAlertInteractor) {
        self.interactor = interactor
    }
}

extension AccountEditAlertPresenter {
    var content: AlertContent {
        guard let interactor else { return .empty }
        return interactor.content
    }
}
