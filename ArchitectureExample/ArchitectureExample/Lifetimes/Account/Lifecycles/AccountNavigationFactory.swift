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

extension ActionSender: ActionSenderForAccountMenuInteractor {}
extension AccountNavigationLifecycle: AccountNavigationLifecycleForAccountMenuInteractor {}
extension AccountMenuLifetime: AccountMenuLifetimeForLifecycle {}
extension AccountNavigationFactory: FactoryForAccountNavigationLifecycle {}

extension AccountNavigationFactory {
    static func makeAccountMenuLifetime(
        lifetimeId: AccountMenuLifetimeId,
        navigationLifecycle: AccountNavigationLifecycle<Self>
    ) -> AccountMenuLifetime {
        guard let appLifetime = LifetimeAccessor.app else {
            fatalError()
        }

        return .init(lifetimeId: lifetimeId,
                     interactor: .init(lifetimeId: lifetimeId,
                                       navigationLifecycle: navigationLifecycle,
                                       actionSender: appLifetime.actionSender))
    }
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
