//
//  RootTransitionViewDependencies.swift
//

import SwiftUI

protocol ChildPresenterForRootTransitionView: ObservableObject {
    var child: RootChild? { get }

    func viewDidAppear()
}

protocol ModalPresenterForRootTransitionView: ObservableObject {
    var isAccountEditSheetPresented: Bool { get set }
    var isLoginFailedAlertPresented: Bool { get set }
    var accountEditSheet: RootAccountEditSheet? { get }
    var loginFailedAlert: RootLoginFailedAlert? { get }
}

protocol FactoryForRootTransitionView {
    static func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter?

    static func makeAccountNavigationPresenter(
        accountLifetimeId: AccountLifetimeId
    ) -> AccountNavigationPresenter?

    static func makeAccountEditTransitionPresenter(
        accountEditLifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionPresenter?
    static func makeAccountEditTransitionModalPresenter(
        accountEditLifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionModalPresenter?

    static func makeLoginFailedAlertPresenter(
        lifetimeId: RootAlertLifetimeId
    ) -> RootLoginFailedAlertPresenter?
}
