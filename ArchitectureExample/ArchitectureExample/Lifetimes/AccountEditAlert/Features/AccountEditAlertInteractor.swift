//
//  AccountEditAlertInteractor.swift
//

/**
 アカウント編集アラート画面の処理
 */

@MainActor
final class AccountEditAlertInteractor {
    typealias ModalLifecycle = AccountEditModalLifecycleForAccountEditAlertInteractor
    typealias AccountEditInteractor = AccountEditInteractorForAccountEditAlertInteractor

    private let lifetimeId: AccountEditAlertLifetimeId
    private let alertId: AccountEditAlertId
    private weak var accountEditInteractor: AccountEditInteractor?
    private weak var modalLifecycle: ModalLifecycle?

    init(lifetimeId: AccountEditAlertLifetimeId,
         alertId: AccountEditAlertId,
         accountEditInteractor: AccountEditInteractor?,
         modalLifecycle: ModalLifecycle?) {
        self.lifetimeId = lifetimeId
        self.alertId = alertId
        self.accountEditInteractor = accountEditInteractor
        self.modalLifecycle = modalLifecycle
    }

    var content: AlertContent<AccountEditAlertId> {
        guard let interactor = self.accountEditInteractor else {
            fatalError()
        }

        return .init(id: self.alertId, interactor: interactor)
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
    func actions(interactor: AccountEditAlertInteractor.AccountEditInteractor) -> [AlertContent<Self>.Action] {
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
         interactor: AccountEditAlertInteractor.AccountEditInteractor) {
        self.init(id: alertId,
                  title: alertId.localizedTitle.value,
                  message: alertId.localizedMessage.value,
                  actions: alertId.actions(interactor: interactor))
    }
}
