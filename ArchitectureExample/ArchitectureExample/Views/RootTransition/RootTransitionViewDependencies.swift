//
//  RootTransitionViewDependencies.swift
//

import SwiftUI

protocol ChildPresenterForRootTransitionView: ObservableObject {
    var child: RootChild? { get }

    func onAppear()
}

protocol ModalPresenterForRootTransitionView: ObservableObject {
    var isAccountEditSheetPresented: Bool { get set }
    var isLoginFailedAlertPresented: Bool { get set }
    var accountEditLifetimeId: AccountEditLifetimeId? { get }
    var loginFailedAlertLifetimeId: RootAlertLifetimeId? { get }
}

protocol FactoryForRootTransitionView {
    associatedtype Command: CommandViewMakeable

    static func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter?

    static func makeAccountNavigationPresenter(
        lifetimeId: AccountLifetimeId
    ) -> AccountNavigationPresenter?

    static func makeAccountEditTransitionPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionPresenter?

    static func makeAccountEditModalPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditModalPresenter?

    static func makeAlertPresenter(
        lifetimeId: RootAlertLifetimeId?
    ) -> RootAlertPresenter?
}
