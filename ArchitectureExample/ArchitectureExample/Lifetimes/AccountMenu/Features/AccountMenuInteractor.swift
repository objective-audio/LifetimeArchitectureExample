//
//  AccountMenuInteractor.swift
//

/**
 アカウントメニュー画面の処理
 */

final class AccountMenuInteractor {
    typealias NavigationLifeCycle = AccountNavigationLifeCycleForAccountMenuInteractor
    typealias ActionSender = ActionSenderForAccountMenuInteractor

    private let lifetimeId: AccountMenuLifetimeId
    private weak var navigationLifecycle: NavigationLifeCycle!
    private weak var actionSender: ActionSender!

    init(lifetimeId: AccountMenuLifetimeId,
         navigationLifecycle: NavigationLifeCycle?,
         actionSender: ActionSender?) {
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
        self.actionSender.sendLogout(accountLifetimeId: self.lifetimeId.account)
    }
}
