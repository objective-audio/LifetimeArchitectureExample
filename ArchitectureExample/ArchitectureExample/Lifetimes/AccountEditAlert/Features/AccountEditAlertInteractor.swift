//
//  AccountEditAlertInteractor.swift
//

/**
 アカウント編集アラート画面の処理
 */

@MainActor
final class AccountEditAlertInteractor {
    let lifetimeId: AccountEditAlertLifetimeId
    let alertId: AccountEditAlertId
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

    func doAction(_ action: AccountEditAlertAction) {
        self.finalize()

        switch action {
        case .cancel:
            break
        case .destruct:
            self.accountEditInteractor.finalize()
        case .logout:
            self.accountEditInteractor.logout()
        }
    }

    func finalize() {
        self.modalLifecycle?.removeAlert(lifetimeId: self.lifetimeId)

        self.modalLifecycle = nil
    }
}
