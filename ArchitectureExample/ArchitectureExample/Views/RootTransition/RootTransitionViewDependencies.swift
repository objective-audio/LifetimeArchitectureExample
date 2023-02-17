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
    func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter?

    func makeAccountNavigationPresenter(
        lifetimeId: AccountLifetimeId
    ) -> AccountNavigationPresenter?

    func makeAccountEditTransitionPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionPresenter?

    func makeAccountEditModalPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditModalPresenter?

    func makeAlertPresenter(
        lifetimeId: RootAlertLifetimeId?
    ) -> RootAlertPresenter?
}
