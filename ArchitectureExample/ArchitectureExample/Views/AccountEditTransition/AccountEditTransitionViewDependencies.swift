//
//  AccountEditTransitionViewDependencies.swift
//

protocol FactoryForAccountEditTransitionView {
    static func makeAccountEditPresenter(
        accountEditLifetimeId: AccountEditLifetimeId
    ) -> AccountEditPresenter?

    static func makeAlertPresenter(
        accountEditAlertLifetimeId: AccountEditAlertLifetimeId
    ) -> AccountEditAlertPresenter?
}
