//
//  RootModalFactory.swift
//

@MainActor
struct RootModalFactory {}

// MARK: -

extension AccountHolder: AccountEditInteractor.AccountHolder {}
extension RootModalLifecycle: AccountEditInteractor.RootModalLifecycle {}
extension AccountEditModalLifecycle: AccountEditInteractor.AccountEditModalLifecycle {}
extension ActionSender: AccountEditInteractor.ActionSender {}

extension AccountEditModalLifecycle: AccountEditReceiver.AccountEditModalLifecycle {}
extension AccountEditInteractor: AccountEditReceiver.AccountEditInteractor {}

extension AccountEditLifetime: AccountEditLifetimeForLifecycle {}
extension AccountEditModalFactory: FactoryForAccountEditModalLifecycle {}

extension RootModalFactory {
    static func makeAccountEditLifetime(lifetimeId: AccountEditLifetimeId) -> AccountEditLifetime {
        let accountLifetimeId = lifetimeId.account

        let appLifetime = LifetimeAccessor.app
        let sceneLifetime = LifetimeAccessor.scene(id: accountLifetimeId.scene)
        let accountLifetime = LifetimeAccessor.account(id: accountLifetimeId)

        let modalLifecycle = AccountEditModalLifecycle<AccountEditModalFactory>(lifetimeId: lifetimeId)
        let interactor = AccountEditInteractor(lifetimeId: lifetimeId,
                                               accountHolder: accountLifetime?.accountHolder,
                                               rootModalLifecycle: sceneLifetime?.rootModalLifecycle,
                                               accountEditModalLifecycle: modalLifecycle,
                                               actionSender: appLifetime?.actionSender)
        let actionReceiver = AccountEditReceiver(accountLifetimeId: accountLifetimeId,
                                                 accountEditModalLifecycle: modalLifecycle,
                                                 interactor: interactor)

        return .init(lifetimeId: lifetimeId,
                     interactor: interactor,
                     modalLifecycle: modalLifecycle,
                     receiver: actionReceiver)
    }
}

// MARK: -

extension RootModalLifecycle: RootModalLifecycleForRootAlertInteractor {}
extension RootAlertLifetime: RootAlertLifetimeForLifecycle {}

extension RootModalFactory {
    static func makeRootAlertLifetime(lifetimeId: RootAlertLifetimeId,
                                      alertId: RootAlertId) -> RootAlertLifetime {
        let sceneLifetime = LifetimeAccessor.scene(id: lifetimeId.scene)

        return .init(lifetimeId: lifetimeId,
                     alertId: alertId,
                     interactor: .init(lifetimeId: lifetimeId,
                                       alertId: alertId,
                                       modalLifecycle: sceneLifetime?.rootModalLifecycle),
                     receiver: .init())
    }
}