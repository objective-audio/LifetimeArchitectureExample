//
//  AccountNavigationHostingController.swift
//

import SwiftUI

typealias AccountNavigationHostingView = AccountNavigationView<AccountNavigationPresenter, AccountNavigationViewFactory>

final class AccountNavigationHostingController: UIHostingController<AccountNavigationHostingView> {
    init(presenter: AccountNavigationPresenter) {
        super.init(rootView: .init(presenter: presenter,
                                   factory: AccountNavigationViewFactory.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
