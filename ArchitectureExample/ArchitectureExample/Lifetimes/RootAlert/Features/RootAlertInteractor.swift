//
//  RootAlertInteractor.swift
//

/**
 ルート階層から出すアラート画面の処理
 */

@MainActor
final class RootAlertInteractor {
    private let lifetimeId: RootAlertLifetimeId
    private let alertId: RootAlertId
    private unowned var modalLifecycle: RootModalLifecycleForRootAlertInteractor?

    init(lifetimeId: RootAlertLifetimeId,
         alertId: RootAlertId,
         modalLifecycle: RootModalLifecycleForRootAlertInteractor) {
        self.lifetimeId = lifetimeId
        self.alertId = alertId
        self.modalLifecycle = modalLifecycle
    }

    var content: AlertContent<RootAlertId> { .init(self.alertId) }

    func finalize() {
        self.modalLifecycle?.removeAlert(lifetimeId: self.lifetimeId)

        self.modalLifecycle = nil
    }
}

// MARK: -

private extension RootAlertId {
    var localizedTitle: Localized {
        switch self {
        case .loginFailed:
            return .alertLoginErrorTitle
        }
    }

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

private extension AlertContent where ID == RootAlertId {
    init(_ content: RootAlertId) {
        self.init(id: content,
                  title: content.localizedTitle.value,
                  message: content.localizedMessage.value,
                  actions: content.actions)
    }
}
