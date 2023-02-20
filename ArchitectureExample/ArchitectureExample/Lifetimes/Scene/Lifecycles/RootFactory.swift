//
//  RootFactory.swift
//

@MainActor
enum RootFactory {}

// MARK: -

extension SceneLifecycle: SceneLifecycleForLaunchInteractor {}
extension RootLifecycle: RootLifecycleForLaunchInteractor {}
extension AccountRepository: AccountRepositoryForLaunchInteractor {}
extension LaunchLifetime: LaunchLifetimeForLifecycle {}

extension RootFactory {
    static func makeLaunchLifetime(sceneLifetimeId: SceneLifetimeId,
                                   rootLifecycle: RootLifecycle<Self>) -> LaunchLifetime {
        guard let appLifetime = LifetimeAccessor.app else {
            fatalError()
        }

        let interactor = LaunchInteractor(sceneLifetimeId: sceneLifetimeId,
                                          sceneLifecycle: appLifetime.sceneLifecycle,
                                          rootLifecycle: rootLifecycle,
                                          accountRepository: appLifetime.accountRepository)

        return .init(sceneLifetimeId: sceneLifetimeId,
                     interactor: interactor)
    }
}

// MARK: -

extension RootLifecycle: RootLifecycleForLoginInteractor {}
extension RootModalLifecycle: RootModalLifecycleForLoginInteractor {}
extension AccountRepository: AccountRepositoryForLoginInteractor {}
extension LoginNetwork: LoginNetworkForLoginInteractor {}
extension LoginLifetime: LoginLifetimeForLifecycle {}

extension RootFactory {
    static func makeLoginLifetime(sceneLifetimeId: SceneLifetimeId) -> LoginLifetime {
        guard let appLifetime = LifetimeAccessor.app,
              let sceneLifetime = LifetimeAccessor.scene(id: sceneLifetimeId) else {
            fatalError()
        }

        let network = LoginNetwork()
        let interactor = LoginInteractor(sceneLifetimeId: sceneLifetimeId,
                                         rootLifecycle: sceneLifetime.rootLifecycle,
                                         rootModalLifecycle: sceneLifetime.rootModalLifecycle,
                                         accountRepository: appLifetime.accountRepository,
                                         network: network)

        return .init(sceneLifetimeId: sceneLifetimeId,
                     network: network,
                     interactor: interactor)
    }
}

// MARK: -

extension RootLifecycle: RootLifecycleForLogoutInteractor {}
extension AccountRepository: AccountRepositoryForLogoutInteractor {}
extension AccountRepository: AccountRepositoryForAccountHolder {}
extension LogoutInteractor: LogoutInteractorForAccountReceiver {}
extension ActionSender: ActionSenderForAccountMenuInteractor {}
extension AccountNavigationLifecycle: AccountNavigationLifecycleForAccountMenuInteractor {}
extension AccountNavigationFactory: FactoryForAccountNavigationLifecycle {}
extension RootModalLifecycle: RootModalLifecycleForAccountReceiver {}
extension AccountLifetime: AccountLifetimeForLifecycle {}

extension RootFactory {
    static func makeAccountLifetime(id: AccountLifetimeId) -> AccountLifetime {
        guard let appLifetime = LifetimeAccessor.app,
              let sceneLifetime = LifetimeAccessor.scene(id: id.scene) else {
            fatalError()
        }

        let accountId = id.accountId
        let logoutInteractor = LogoutInteractor(accountId: accountId,
                                                rootLifecycle: sceneLifetime.rootLifecycle,
                                                accountRepository: appLifetime.accountRepository)
        let navigationLifecycle = AccountNavigationLifecycle(accountLifetimeId: id,
                                                             factory: AccountNavigationFactory.self)

        return .init(lifetimeId: id,
                     accountHolder: .init(id: accountId,
                                              accountRepository: appLifetime.accountRepository),
                     logoutInteractor: logoutInteractor,
                     navigationLifecycle: navigationLifecycle,
                     accountMenuInteractor: .init(lifetimeId: id,
                                                  navigationLifecycle: navigationLifecycle,
                                                  actionSender: appLifetime.actionSender),
                     receiver: .init(accountLifetimeId: id,
                                     logoutInteractor: logoutInteractor,
                                     rootModalLifecycle: sceneLifetime.rootModalLifecycle))
    }
}
