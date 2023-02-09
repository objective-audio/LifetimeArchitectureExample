//
//  AccountMenuInteractor.swift
//

/**
 アカウントメニュー画面の処理
 */

final class AccountMenuInteractor {
    private let lifetimeId: AccountLifetimeId
    private unowned let navigationLifecycle: AccountNavigationLifecycleForAccountMenuInteractor
    private unowned let actionSender: ActionSenderForAccountMenuInteractor

    init(lifetimeId: AccountLifetimeId,
         navigationLifecycle: AccountNavigationLifecycleForAccountMenuInteractor,
         actionSender: ActionSenderForAccountMenuInteractor) {
        self.lifetimeId = lifetimeId
        self.navigationLifecycle = navigationLifecycle
        self.actionSender = actionSender
    }

    func pushInfo(uiSystem: UISystem) {
        guard self.navigationLifecycle.canPushInfo else {
            assertionFailureIfNotTest()
            return
        }

        self.navigationLifecycle.pushInfo(uiSystem: uiSystem)
    }

    func logout() {
        self.actionSender.sendLogout(accountLifetimeId: self.lifetimeId)
    }
}
