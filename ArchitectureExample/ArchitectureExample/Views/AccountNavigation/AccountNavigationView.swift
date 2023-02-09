//
//  AccountNavigationView.swift
//

import SwiftUI

struct AccountNavigationView<Presenter: PresenterForAccountNavigationView,
                             Factory: FactoryForAccountNavigationView>: View {
    @ObservedObject private var presenter: Presenter

    init(presenter: Presenter) {
        self.presenter = presenter
    }

    var body: some View {
        NavigationStack(path: $presenter.elements) {
            Group {
                if let presenter = Factory.makeAccountMenuPresenter(lifetimeId: presenter.accountLifetimeId) {
                    AccountMenuView(presenter: presenter)
                } else {
                    Text("AccountMenuView")
                }
            }
            .navigationDestination(for: AccountNavigationElement.self) {
                switch $0 {
                case .info(let uiSystem, let lifetimeId):
                    switch uiSystem {
                    case .swiftUI:
                        if let presenter = Factory.makeAccountInfoSwiftUIPresenter(lifetimeId: lifetimeId) {
                            AccountInfoView(presenter: presenter)
                        } else {
                            Text("AccountInfoView")
                        }
                    case .uiKit:
                        if let presenter = Factory.makeAccountInfoUIKitPresenter(lifetimeId: lifetimeId) {
                            AccountInfoUIKitView(presenter: presenter)
                        } else {
                            Text("AccountInfoUIKitView")
                        }
                    }
                case .detail(let lifetimeId):
                    if let presenter = Factory.makeAccountDetailPresenter(lifetimeId: lifetimeId) {
                        AccountDetailView(presenter: presenter)
                    } else {
                        Text("AccountDetailView")
                    }
                }
            }
        }
    }
}

// MARK: -

private class PreviewPresenter: PresenterForAccountNavigationView {
    private static let accountId: AccountLifetimeId = .init(scene: .init(instanceId: .init()),
                                                            accountId: 0)
    var accountLifetimeId: AccountLifetimeId = accountId
    var elements: [AccountNavigationElement] = [
        .info(uiSystem: .uiKit, lifetimeId: .init(instanceId: .init(),
                                                  account: accountId)),
        .detail(lifetimeId: .init(instanceId: .init(),
                                  account: accountId))
    ]
}

private enum PreviewFactory: FactoryForAccountNavigationView {
    static func makeAccountMenuPresenter(lifetimeId: AccountLifetimeId) -> AccountMenuPresenter? {
        nil
    }

    static func makeAccountInfoSwiftUIPresenter(lifetimeId: AccountInfoLifetimeId) -> AccountInfoSwiftUIPresenter? {
        nil
    }

    static func makeAccountInfoUIKitPresenter(lifetimeId: AccountInfoLifetimeId) -> AccountInfoUIKitPresenter? {
        nil
    }

    static func makeAccountDetailPresenter(lifetimeId: AccountDetailLifetimeId) -> AccountDetailPresenter? {
        nil
    }
}

struct AccountNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountNavigationView<PreviewPresenter, PreviewFactory>(presenter: PreviewPresenter())
        .environment(\.locale, .init(identifier: "ja"))
    }
}
