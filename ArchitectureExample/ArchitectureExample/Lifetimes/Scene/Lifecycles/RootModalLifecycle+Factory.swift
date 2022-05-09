//
//  RootModalLifecycle+Factory.swift
//

extension AccountHolder: AccountEditInteractor.AccountHolder {}
extension RootModalLifecycle: AccountEditInteractor.RootModalLifecycle {}
extension AccountEditModalLifecycle: AccountEditInteractor.AccountEditModalLifecycle {}
extension ActionSender: AccountEditInteractor.ActionSender {}

extension AccountEditModalLifecycle: AccountEditReceiver.AccountEditModalLifecycle {}
extension AccountEditInteractor: AccountEditReceiver.AccountEditInteractor {}

extension RootModalLifecycle {
    static func makeAccountEditLifetime(lifetimeId: AccountEditLifetimeId) -> AccountEditLifetime<Accessor> {
        let accountLifetimeId = lifetimeId.account

        let appLifetime = Accessor.app
        let sceneLifetime = Accessor.scene(id: accountLifetimeId.scene)
        let accountLifetime = Accessor.account(id: accountLifetimeId)

        let modalLifecycle = AccountEditModalLifecycle<Accessor>(lifetimeId: lifetimeId)
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

extension RootModalLifecycle {
    static func makeRootAlertLifetime(lifetimeId: RootAlertLifetimeId,
                                      alertId: RootAlertId) -> RootAlertLifetime {
        let sceneLifetime = Accessor.scene(id: lifetimeId.scene)

        return .init(lifetimeId: lifetimeId,
                     alertId: alertId,
                     interactor: .init(lifetimeId: lifetimeId,
                                       alertId: alertId,
                                       modalLifecycle: sceneLifetime?.rootModalLifecycle),
                     receiver: .init())
    }
}
