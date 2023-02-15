//
//  AccountEditAlertPresenter.swift
//

import SwiftUI

@MainActor
final class AccountEditAlertPresenter {
    private weak var interactor: AccountEditAlertInteractor?

    init(interactor: AccountEditAlertInteractor) {
        self.interactor = interactor
    }
}

extension AccountEditAlertPresenter {
    var message: Localized {
        self.interactor?.alertId.message ?? .empty
    }

    var actions: [AccountEditAlertAction] {
        self.interactor?.alertId.actions ?? []
    }

    func doAction(_ action: AccountEditAlertAction) {
        self.interactor?.doAction(action)
    }
}

extension AccountEditAlertAction {
    var role: ButtonRole {
        switch self {
        case .cancel:
            return .cancel
        case .logout, .destruct:
            return .destructive
        }
    }

    var title: Localized {
        switch self {
        case .cancel:
            return .alertAccountEditCancel
        case .logout:
            return .alertAccountEditLogout
        case .destruct:
            return .alertAccountEditDestruct
        }
    }
}

private extension AccountEditAlertId {
    var message: Localized {
        switch self {
        case .destruct:
            return .alertAccountEditDestructionMessage
        case .logout:
            return .alertAccountEditLogoutMessage
        }
    }

    var actions: [AccountEditAlertAction] {
        switch self {
        case .destruct:
            return [.cancel, .destruct]
        case .logout:
            return [.cancel, .logout]
        }
    }
}
