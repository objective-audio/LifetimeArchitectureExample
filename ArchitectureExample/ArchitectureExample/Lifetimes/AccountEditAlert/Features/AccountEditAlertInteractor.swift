//
//  AccountEditAlertInteractor.swift
//

/**
 アカウント編集アラート画面の処理
 */

@MainActor
final class AccountEditAlertInteractor {
    private let lifetimeId: AccountEditAlertLifetimeId
    private let alertId: AccountEditAlertId
    private unowned var accountEditInteractor: AccountEditInteractorForAccountEditAlertInteractor
    private unowned var modalLifecycle: AccountEditModalLifecycleForAccountEditAlertInteractor?

    init(lifetimeId: AccountEditAlertLifetimeId,
         alertId: AccountEditAlertId,
         accountEditInteractor: AccountEditInteractorForAccountEditAlertInteractor,
         modalLifecycle: AccountEditModalLifecycleForAccountEditAlertInteractor) {
        self.lifetimeId = lifetimeId
        self.alertId = alertId
        self.accountEditInteractor = accountEditInteractor
        self.modalLifecycle = modalLifecycle
    }

    var content: AlertContent {
        .init(message: self.alertId.localizedMessage,
              actions: self.alertId.actions(interactor: self.accountEditInteractor))
    }

    func finalize() {
        self.modalLifecycle?.removeAlert(lifetimeId: self.lifetimeId)

        self.modalLifecycle = nil
    }
}

// MARK: -

private extension AccountEditAlertId {
    var localizedMessage: Localized {
        switch self {
        case .destruct:
            return .alertAccountEditDestructionMessage
        case .logout:
            return .alertAccountEditLogoutMessage
        }
    }

    @MainActor
    func actions(interactor: AccountEditInteractorForAccountEditAlertInteractor) -> [AlertContent.Action] {
        switch self {
        case .destruct:
            return [.init(title: .alertAccountEditCancel,
                          role: .cancel,
                          handler: {}),
                    .init(title: .alertAccountEditDestruct,
                          role: .destructive,
                          handler: { [weak interactor] in interactor?.finalize() })]
        case .logout:
            return [.init(title: .alertAccountEditCancel,
                          role: .cancel,
                          handler: {}),
                    .init(title: .alertAccountEditLogout,
                          role: .destructive,
                          handler: { [weak interactor] in interactor?.logout() })]
        }
    }
}
