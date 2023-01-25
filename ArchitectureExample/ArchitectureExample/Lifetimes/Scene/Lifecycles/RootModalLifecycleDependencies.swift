//
//  RootModalLifecycleDependencies.swift
//

protocol RootAlertLifetimeForLifecycle {
    var lifetimeId: RootAlertLifetimeId { get }
    var alertId: RootAlertId { get }
    var interactor: RootAlertInteractor { get }
    var receiver: RootAlertReceiver { get }
}

protocol AccountEditLifetimeForLifecycle {
    var lifetimeId: AccountEditLifetimeId { get }
    var interactor: AccountEditInteractor { get }
    var modalLifecycle: AccountEditModalLifecycle<AccountEditModalFactory> { get }
    var receiver: AccountEditReceiver { get }
}

protocol FactoryForRootModalLifecycle {
    associatedtype AccountEditLifetime: AccountEditLifetimeForLifecycle
    associatedtype RootAlertLifetime: RootAlertLifetimeForLifecycle

    static func makeAccountEditLifetime(lifetimeId: AccountEditLifetimeId) -> AccountEditLifetime
    static func makeRootAlertLifetime(lifetimeId: RootAlertLifetimeId,
                                      alertId: RootAlertId) -> RootAlertLifetime
}
