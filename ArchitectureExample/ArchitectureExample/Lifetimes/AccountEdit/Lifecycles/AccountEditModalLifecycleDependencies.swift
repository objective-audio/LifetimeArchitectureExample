//
//  AccountEditModalLifecycleDependencies.swift
//

protocol AccountEditAlertLifetimeForLifecycle {
    var lifetimeId: AccountEditAlertLifetimeId { get }
    var alertId: AccountEditAlertId { get }
    var interactor: AccountEditAlertInteractor { get }
    var receiver: AccountEditAlertReceiver { get }
}

protocol FactoryForAccountEditModalLifecycle {
    associatedtype AccountEditAlertLifetime: AccountEditAlertLifetimeForLifecycle

    static func makeAccountEditAlertLifetime(lifetimeId: AccountEditAlertLifetimeId,
                                             alertId: AccountEditAlertId) -> AccountEditAlertLifetime
}
