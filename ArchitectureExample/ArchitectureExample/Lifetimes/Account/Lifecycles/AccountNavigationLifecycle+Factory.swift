//
//  AccountNavigationLifecycle+Factory.swift
//

import Combine

// MARK: -

extension ActionSender: AccountMenuInteractor.ActionSender {}
extension AccountNavigationLifecycle: AccountMenuInteractor.NavigationLifeCycle {}

extension AccountNavigationLifecycle {
    static func makeAccountMenuLifetime(lifetimeId: AccountMenuLifetimeId) -> AccountMenuLifetime {
        let appLifetime = Accessor.app
        let accountLifetime = Accessor.account(id: lifetimeId.account)

        return .init(lifetimeId: lifetimeId,
                     interactor: .init(lifetimeId: lifetimeId,
                                       navigationLifecycle: accountLifetime?.navigationLifecycle,
                                       actionSender: appLifetime?.actionSender))
    }
}

// MARK: -

extension AccountNavigationLifecycle: AccountInfoInteractor.NavigationLifecycle {}
extension AccountHolder: AccountInfoInteractor.AccountHolder {}
extension RootModalLifecycle: AccountInfoInteractor.RootModalLifecycle {}

extension AccountNavigationLifecycle {
    static func makeAccountInfoLifetime(lifetimeId: AccountInfoLifetimeId,
                                        uiSystem: UISystem) -> AccountInfoLifetime {
        let sceneLifetime = Accessor.scene(id: lifetimeId.account.scene)
        let accountLifetime = Accessor.account(id: lifetimeId.account)

        return .init(lifetimeId: lifetimeId,
                     interactor: .init(uiSystem: uiSystem,
                                       lifetimeId: lifetimeId,
                                       accountHolder: accountLifetime?.accountHolder,
                                       navigationLifecycle: accountLifetime?.navigationLifecycle,
                                       rootModalLifecycle: sceneLifetime?.rootModalLifecycle))
    }
}
