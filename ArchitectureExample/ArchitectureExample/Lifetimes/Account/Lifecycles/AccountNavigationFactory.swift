//
//  AccountNavigationFactory.swift
//

import Combine

@MainActor
enum AccountNavigationFactory {}

// MARK: -

extension AccountNavigationFactory {
    static func makeInstanceId() -> InstanceId { .init() }
}

// MARK: -

extension AccountNavigationLifecycle: AccountNavigationLifecycleForAccountInfoInteractor {}
extension AccountHolder: AccountHolderForAccountInfoInteractor {}
extension RootModalLifecycle: RootModalLifecycleForAccountInfoInteractor {}
extension AccountInfoLifetime: AccountInfoLifetimeForLifecycle {}

extension AccountNavigationFactory {
    static func makeAccountInfoLifetime(
        lifetimeId: AccountInfoLifetimeId,
        uiSystem: UISystem
    ) -> AccountInfoLifetime {
        guard let sceneLifetime = LifetimeAccessor.scene(id: lifetimeId.account.scene),
              let accountLifetime = LifetimeAccessor.account(id: lifetimeId.account) else {
            fatalError()
        }

        return .init(lifetimeId: lifetimeId,
                     uiSystem: uiSystem,
                     interactor: .init(uiSystem: uiSystem,
                                       lifetimeId: lifetimeId,
                                       accountHolder: accountLifetime.accountHolder,
                                       navigationLifecycle: accountLifetime.navigationLifecycle,
                                       rootModalLifecycle: sceneLifetime.rootModalLifecycle))
    }
}

// MARK: -

extension AccountNavigationLifecycle: AccountNavigationLifecycleForAccountDetailInteractor {}
extension AccountDetailLifetime: AccountDetailLifetimeForLifecycle {}

extension AccountNavigationFactory {
    static func makeAccountDetailLifetime(lifetimeId: AccountDetailLifetimeId) -> AccountDetailLifetime {
        guard let accountLifetime = LifetimeAccessor.account(id: lifetimeId.account) else {
            fatalError()
        }

        return .init(lifetimeId: lifetimeId,
                     interactor: .init(lifetimeId: lifetimeId,
                                       navigationLifecycle: accountLifetime.navigationLifecycle))
    }
}
