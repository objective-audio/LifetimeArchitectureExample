//
//  AccountNavigationFactory.swift
//

import Combine

@MainActor
struct AccountNavigationFactory {}

// MARK: -

extension ActionSender: AccountMenuInteractor.ActionSender {}
extension AccountNavigationLifecycle: AccountMenuInteractor.NavigationLifecycle {}
extension AccountMenuLifetime: AccountMenuLifetimeForLifecycle {}
extension AccountNavigationFactory: FactoryForAccountNavigationLifecycle {}

extension AccountNavigationFactory {
    static func makeAccountMenuLifetime(
        lifetimeId: AccountMenuLifetimeId,
        navigationLifecycle: AccountNavigationLifecycle<Self>
    ) -> AccountMenuLifetime {
        let appLifetime = LifetimeAccessor.app

        return .init(lifetimeId: lifetimeId,
                     interactor: .init(lifetimeId: lifetimeId,
                                       navigationLifecycle: navigationLifecycle,
                                       actionSender: appLifetime?.actionSender))
    }
}

// MARK: -

extension AccountNavigationLifecycle: AccountInfoInteractor.NavigationLifecycle {}
extension AccountHolder: AccountInfoInteractor.AccountHolder {}
extension RootModalLifecycle: AccountInfoInteractor.RootModalLifecycle {}
extension AccountInfoLifetime: AccountInfoLifetimeForLifecycle {}

extension AccountNavigationFactory {
    static func makeAccountInfoLifetime(
        lifetimeId: AccountInfoLifetimeId,
        uiSystem: UISystem
    ) -> AccountInfoLifetime {
        let sceneLifetime = LifetimeAccessor.scene(id: lifetimeId.account.scene)
        let accountLifetime = LifetimeAccessor.account(id: lifetimeId.account)

        return .init(lifetimeId: lifetimeId,
                     uiSystem: uiSystem,
                     interactor: .init(uiSystem: uiSystem,
                                       lifetimeId: lifetimeId,
                                       accountHolder: accountLifetime?.accountHolder,
                                       navigationLifecycle: accountLifetime?.navigationLifecycle,
                                       rootModalLifecycle: sceneLifetime?.rootModalLifecycle))
    }
}

// MARK: -

extension AccountNavigationLifecycle: AccountDetailInteractor.NavigationLifecycle {}
extension AccountDetailLifetime: AccountDetailLifetimeForLifecycle {}

extension AccountNavigationFactory {
    static func makeAccountDetailLifetime(lifetimeId: AccountDetailLifetimeId) -> AccountDetailLifetime {
        let accountLifetime = LifetimeAccessor.account(id: lifetimeId.account)

        return .init(lifetimeId: lifetimeId,
                     interactor: .init(lifetimeId: lifetimeId,
                                       navigationLifecycle: accountLifetime?.navigationLifecycle))
    }
}
