//
//  AccountDetailInteractor.swift
//

/**
 アカウント詳細画面の処理
 */

@MainActor
final class AccountDetailInteractor {
    private let lifetimeId: AccountDetailLifetimeId

    private unowned var navigationLifecycle: AccountNavigationLifecycleForAccountDetailInteractor?

    init(lifetimeId: AccountDetailLifetimeId,
         navigationLifecycle: AccountNavigationLifecycleForAccountDetailInteractor) {
        self.lifetimeId = lifetimeId
        self.navigationLifecycle = navigationLifecycle
    }

    func finalize() {
        guard let lifecycle = self.navigationLifecycle,
              lifecycle.canPopDetail(lifetimeId: self.lifetimeId) else {
            return
        }

        lifecycle.popDetail(lifetimeId: self.lifetimeId)

        self.navigationLifecycle = nil
    }
}
