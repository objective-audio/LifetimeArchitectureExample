//
//  RootModalFactory.swift
//

@MainActor
enum RootModalFactory {}

// MARK: -

extension RootModalFactory {
    static func makeInstanceId() -> InstanceId { .init() }
}

// MARK: -

extension AccountHolder: AccountHolderForAccountEditInteractor {}
extension RootModalLifecycle: RootModalLifecycleForAccountEditInteractor {}
extension AccountEditModalLifecycle: AccountEditModalLifecycleForAccountEditInteractor {}
extension ActionSender: ActionSenderForAccountEditInteractor {}

extension AccountEditModalLifecycle: AccountEditModalLifecycleForAccountEditReceiver {}
extension AccountEditInteractor: AccountEditInteractorForAccountEditReceiver {}

extension AccountEditLifetime: AccountEditLifetimeForLifecycle {}
extension AccountEditModalFactory: FactoryForAccountEditModalLifecycle {}

extension RootModalFactory {
    static func makeAccountEditLifetime(lifetimeId: AccountEditLifetimeId) -> AccountEditLifetime {
        let accountLifetimeId = lifetimeId.account

        guard let appLifetime = LifetimeAccessor.app,
              let sceneLifetime = LifetimeAccessor.scene(id: accountLifetimeId.scene),
              let accountLifetime = LifetimeAccessor.account(id: accountLifetimeId) else {
            fatalError()
        }

        let modalLifecycle = AccountEditModalLifecycle<AccountEditModalFactory>(lifetimeId: lifetimeId)
        let interactor = AccountEditInteractor(lifetimeId: lifetimeId,
                                               accountHolder: accountLifetime.accountHolder,
                                               rootModalLifecycle: sceneLifetime.rootModalLifecycle,
                                               accountEditModalLifecycle: modalLifecycle,
                                               actionSender: appLifetime.actionSender)
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
        guard let sceneLifetime = LifetimeAccessor.scene(id: lifetimeId.scene) else {
            fatalError()
        }

        return .init(lifetimeId: lifetimeId,
                     alertId: alertId,
                     interactor: .init(lifetimeId: lifetimeId,
                                       alertId: alertId,
                                       modalLifecycle: sceneLifetime.rootModalLifecycle),
                     receiver: .init())
    }
}
