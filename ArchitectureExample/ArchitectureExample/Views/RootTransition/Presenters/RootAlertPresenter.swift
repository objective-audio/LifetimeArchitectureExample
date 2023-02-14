//
//  RootAlertPresenter.swift
//

final class RootAlertPresenter {
    private weak var interactor: RootAlertInteractor?

    init(interactor: RootAlertInteractor) {
        self.interactor = interactor
    }

    var content: AlertContent {
        guard let interactor else { return .empty }
        return .init(message: interactor.alertId.localizedMessage,
                     actions: interactor.alertId.actions)
    }
}

private extension RootAlertId {
    var localizedMessage: Localized {
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

    var actions: [AlertContent.Action] {
        switch self {
        case .loginFailed:
            return [.init(title: .alertOK,
                          role: .cancel,
                          handler: {})]
        }
    }
}
