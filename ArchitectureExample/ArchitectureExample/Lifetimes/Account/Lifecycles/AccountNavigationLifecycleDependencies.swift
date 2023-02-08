//
//  AccountNavigationLifecycleDependencies.swift
//

protocol AccountInfoLifetimeForLifecycle {
    var lifetimeId: AccountInfoLifetimeId { get }
    var uiSystem: UISystem { get }
    var interactor: AccountInfoInteractor { get }
}

protocol AccountDetailLifetimeForLifecycle {
    var lifetimeId: AccountDetailLifetimeId { get }
    var interactor: AccountDetailInteractor { get }
}

protocol FactoryForAccountNavigationLifecycle {
    associatedtype AccountInfoLifetime: AccountInfoLifetimeForLifecycle
    associatedtype AccountDetailLifetime: AccountDetailLifetimeForLifecycle

    static func makeInstanceId() -> InstanceId
    static func makeAccountInfoLifetime(lifetimeId: AccountInfoLifetimeId,
                                        uiSystem: UISystem) -> AccountInfoLifetime
    static func makeAccountDetailLifetime(lifetimeId: AccountDetailLifetimeId) -> AccountDetailLifetime
}
