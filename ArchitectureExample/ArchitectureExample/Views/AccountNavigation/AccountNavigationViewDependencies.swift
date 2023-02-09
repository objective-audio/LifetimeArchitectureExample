//
//  AccountNavigationViewDependencies.swift
//

import Foundation

protocol PresenterForAccountNavigationView: ObservableObject {
    var accountLifetimeId: AccountLifetimeId { get }

    var elements: [AccountNavigationElement] { get set }
}

protocol FactoryForAccountNavigationView {
    static func makeAccountMenuPresenter(
        lifetimeId: AccountLifetimeId
    ) -> AccountMenuPresenter?

    static func makeAccountInfoSwiftUIPresenter(
        lifetimeId: AccountInfoLifetimeId
    ) -> AccountInfoSwiftUIPresenter?

    static func makeAccountInfoUIKitPresenter(
        lifetimeId: AccountInfoLifetimeId
    ) -> AccountInfoUIKitPresenter?

    static func makeAccountDetailPresenter(
        lifetimeId: AccountDetailLifetimeId
    ) -> AccountDetailPresenter?
}
