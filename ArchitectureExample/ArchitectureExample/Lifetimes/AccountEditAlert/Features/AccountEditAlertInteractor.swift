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

    var content: AlertContent<AccountEditAlertId> {
        return .init(id: self.alertId,
                     interactor: self.accountEditInteractor)
    }

    func finalize() {
        self.modalLifecycle?.removeAlert(lifetimeId: self.lifetimeId)

        self.modalLifecycle = nil
    }
}

// MARK: -

private extension AccountEditAlertId {
    var localizedTitle: Localized {
        switch self {
        case .destruct:
            return .alertAccountEditDestructionTitle
        case .logout:
            return .alertAccountEditLogoutTitle
        }
    }

    var localizedMessage: Localized {
        switch self {
        case .destruct:
            return .alertAccountEditDestructionMessage
        case .logout:
            return .alertAccountEditLogoutMessage
        }
    }

    @MainActor
    func actions(interactor: AccountEditInteractorForAccountEditAlertInteractor) -> [AlertContent<Self>.Action] {
        switch self {
        case .destruct:
            return [.init(title: Localized.alertAccountEditCancel.value,
                          style: .cancel,
                          handler: {}),
                    .init(title: Localized.alertAccountEditDestruct.value,
                          style: .destructive,
                          handler: { [weak interactor] in interactor?.finalize() })]
        case .logout:
            return [.init(title: Localized.alertAccountEditCancel.value,
                          style: .cancel,
                          handler: {}),
                    .init(title: Localized.alertAccountEditLogout.value,
                          style: .destructive,
                          handler: { [weak interactor] in interactor?.logout() })]
        }
    }
}

private extension AlertContent where ID == AccountEditAlertId {
    @MainActor
    init(id alertId: AccountEditAlertId,
         interactor: AccountEditInteractorForAccountEditAlertInteractor) {
        self.init(id: alertId,
                  title: alertId.localizedTitle.value,
                  message: alertId.localizedMessage.value,
                  actions: alertId.actions(interactor: interactor))
    }
}
