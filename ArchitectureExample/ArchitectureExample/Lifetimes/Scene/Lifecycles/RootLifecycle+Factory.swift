//
//  RootLifecycle+Factory.swift
//

// MARK: -

extension SceneLifecycle: LaunchInteractor.SceneLifecycle {}
extension RootLifecycle: LaunchInteractor.RootLifecycle {}
extension AccountRepository: LaunchInteractor.AccountRepository {}

extension RootLifecycle {
    static func makeLaunchLifetime(sceneLifetimeId: SceneLifetimeId) -> LaunchLifetime {
        let appLifetime = Accessor.app
        let sceneLifetime = Accessor.scene(id: sceneLifetimeId)

        let interactor = LaunchInteractor(sceneLifetimeId: sceneLifetimeId,
                                          sceneLifecycle: appLifetime?.sceneLifecycle,
                                          rootLifecycle: sceneLifetime?.rootLifecycle,
                                          accountRepository: appLifetime?.accountRepository)

        return .init(sceneLifetimeId: sceneLifetimeId,
                     interactor: interactor)
    }
}

// MARK: -

extension RootLifecycle: LoginInteractor.RootLifecycle {}
extension RootModalLifecycle: LoginInteractor.RootModalLifecycle {}
extension AccountRepository: LoginInteractor.AccountRepository {}
extension LoginNetwork: LoginInteractor.Network {}

extension RootLifecycle {
    static func makeLoginLifetime(sceneLifetimeId: SceneLifetimeId) -> LoginLifetime {
        let appLifetime = Accessor.app
        let sceneLifetime = Accessor.scene(id: sceneLifetimeId)

        let network = LoginNetwork()
        let interactor = LoginInteractor(sceneLifetimeId: sceneLifetimeId,
                                         rootLifecycle: sceneLifetime?.rootLifecycle,
                                         rootModalLifecycle: sceneLifetime?.rootModalLifecycle,
                                         accountRepository: appLifetime?.accountRepository,
                                         network: network)

        return .init(sceneLifetimeId: sceneLifetimeId,
                     network: network,
                     interactor: interactor)
    }
}

// MARK: -

extension RootLifecycle: LogoutInteractor.RootLifecycle {}
extension AccountRepository: LogoutInteractor.AccountRepository {}
extension AccountRepository: AccountHolder.Repository {}
extension LogoutInteractor: AccountReceiver.LogoutInteractor {}

extension RootLifecycle {
    static func makeAccountLifetime(id: AccountLifetimeId) -> AccountLifetime<Accessor> {
        let appLifetime = Accessor.app
        let sceneLifetime = Accessor.scene(id: id.scene)
        let accountId = id.accountId
        let logoutInteractor = LogoutInteractor(accountId: accountId,
                                                rootLifecycle: sceneLifetime?.rootLifecycle,
                                                accountRepository: appLifetime?.accountRepository)

        return .init(lifetimeId: id,
                     accountHolder: .init(id: accountId,
                                              accountRepository: appLifetime?.accountRepository),
                     logoutInteractor: logoutInteractor,
                     navigationLifecycle: .init(accountLifetimeId: id),
                     receiver: .init(accountLifetimeId: id,
                                     logoutInteractor: logoutInteractor,
                                     rootModalLifecycle: sceneLifetime?.rootModalLifecycle))
    }
}
