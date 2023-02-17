//
//  AccountEditTransitionViewDependencies.swift
//

import Foundation

protocol TransitionPresenterForAccountEditTransitionView: ObservableObject {
    var accountEditLifetimeId: AccountEditLifetimeId { get }
    var interactiveDismissDisabled: Bool { get }

    func onDisappear()
}

protocol ModalPresenterForAccountEditTransitionView: ObservableObject {
    var isDestructAlertPresented: Bool { get set }
    var isLogoutAlertPresented: Bool { get set }

    var destructAlertLifetimeId: AccountEditAlertLifetimeId? { get }
    var logoutAlertLifetimeId: AccountEditAlertLifetimeId? { get }
}

protocol FactoryForAccountEditTransitionView {
    func makeAccountEditPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditPresenter?

    func makeAlertPresenter(
        lifetimeId: AccountEditAlertLifetimeId?
    ) -> AccountEditAlertPresenter?
}
