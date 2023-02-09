//
//  RootLifecycleDependencies.swift
//

protocol LaunchLifetimeForLifecycle {
    var sceneLifetimeId: SceneLifetimeId { get }
    var interactor: LaunchInteractor { get }
}

protocol LoginLifetimeForLifecycle {
    var sceneLifetimeId: SceneLifetimeId { get }
    var network: LoginNetwork { get }
    var interactor: LoginInteractor { get }
}

protocol AccountLifetimeForLifecycle {
    var lifetimeId: AccountLifetimeId { get }
    var accountHolder: AccountHolder { get }
    var logoutInteractor: LogoutInteractor { get }
    var navigationLifecycle: AccountNavigationLifecycle<AccountNavigationFactory> { get }
    var accountMenuInteractor: AccountMenuInteractor { get }
    var receiver: AccountReceiver { get }
}

protocol FactoryForRootLifecycle {
    associatedtype LaunchLifetime: LaunchLifetimeForLifecycle
    associatedtype LoginLifetime: LoginLifetimeForLifecycle
    associatedtype AccountLifetime: AccountLifetimeForLifecycle

    static func makeLaunchLifetime(sceneLifetimeId: SceneLifetimeId,
                                   rootLifecycle: RootLifecycle<Self>) -> LaunchLifetime
    static func makeLoginLifetime(sceneLifetimeId: SceneLifetimeId) -> LoginLifetime
    static func makeAccountLifetime(id: AccountLifetimeId) -> AccountLifetime
}
