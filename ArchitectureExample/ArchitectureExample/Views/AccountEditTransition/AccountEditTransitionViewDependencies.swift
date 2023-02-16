//
//  AccountEditTransitionViewDependencies.swift
//

protocol FactoryForAccountEditTransitionView {
    static func makeAccountEditPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditPresenter?

    static func makeAlertPresenter(
        lifetimeId: AccountEditAlertLifetimeId?
    ) -> AccountEditAlertPresenter?
}
