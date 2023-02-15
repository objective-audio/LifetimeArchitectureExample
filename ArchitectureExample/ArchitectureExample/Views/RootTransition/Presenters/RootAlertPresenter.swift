//
//  RootAlertPresenter.swift
//

import SwiftUI

@MainActor
final class RootAlertPresenter {
    private weak var interactor: RootAlertInteractor?

    init(interactor: RootAlertInteractor) {
        self.interactor = interactor
    }
}

extension RootAlertPresenter {
    var content: RootAlertContent {
        guard let alertId = self.interactor?.alertId else {
            return .empty
        }

        return .init(message: alertId.message,
                     actions: alertId.actions)
    }

    func doAction(_ action: RootAlertAction) {
        self.interactor?.doAction(action)
    }
}

extension RootAlertAction {
    var role: ButtonRole {
        switch self {
        case .alertOK:
            return .cancel
        }
    }

    var title: Localized {
        switch self {
        case .alertOK:
            return .alertOK
        }
    }
}

private extension RootAlertId {
    var message: Localized {
        switch self {
        case .loginFailed(let kind):
            switch kind {
            case .accountDuplicated:
                return .alertLoginAccountDuplicatedMessage
            case .invalidAccountID:
                return .alertLoginInvalidAccountIDMessage
            case .cancelled:
                return .alertLoginCancelledMessage
            case .other:
                return .alertLoginFailedMessage
            }
        }
    }

    var actions: [RootAlertAction] {
        switch self {
        case .loginFailed:
            return [.alertOK]
        }
    }
}
