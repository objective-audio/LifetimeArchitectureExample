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
    var modal: RootModal? { get }
}

protocol FactoryForRootTransitionView {
    static func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter?

    static func makeAccountNavigationPresenter(
        lifetimeId: AccountLifetimeId
    ) -> AccountNavigationPresenter?

    static func makeAccountEditTransitionPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionPresenter?
    static func makeAccountEditTransitionModalPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditModalPresenter?

    static func makeAlertPresenter(
        lifetimeId: RootAlertLifetimeId
    ) -> RootAlertPresenter?
}
