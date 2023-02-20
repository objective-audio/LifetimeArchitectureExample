//
//  AccountEditTransitionViewDependencies.swift
//

import Foundation

protocol TransitionPresenterForAccountEditTransitionView: ObservableObject {
    var accountEditLifetimeId: AccountEditLifetimeId { get }
    var interactiveDismissDisabled: Bool { get }

    func onDisappear()
}

extension TransitionPresenterForAccountEditTransitionView {
    var sceneLifetimeId: SceneLifetimeId { accountEditLifetimeId.account.scene }
}

protocol ModalPresenterForAccountEditTransitionView: ObservableObject {
    var isDestructAlertPresented: Bool { get set }
    var isLogoutAlertPresented: Bool { get set }

    var destructAlertLifetimeId: AccountEditAlertLifetimeId? { get }
    var logoutAlertLifetimeId: AccountEditAlertLifetimeId? { get }
}

protocol FactoryForAccountEditTransitionView {
    associatedtype Command: CommandViewMakeable

    static func makeAccountEditPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditPresenter?

    static func makeAlertPresenter(
        lifetimeId: AccountEditAlertLifetimeId?
    ) -> AccountEditAlertPresenter?
}
