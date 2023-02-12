//
//  RootLoginFailedAlertPresenter.swift
//

final class RootLoginFailedAlertPresenter {
    let alertId: RootAlertId

    init(interactor: RootAlertInteractor) {
        self.alertId = interactor.alertId
    }
}

extension RootAlertId {
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

    var actions: [AlertContent<Self>.Action] {
        switch self {
        case .loginFailed:
            return [.init(title: Localized.alertOK.value,
                          style: .default,
                          handler: {})]
        }
    }
}
