//
//  AccountNavigationHostingController.swift
//

import SwiftUI

typealias AccountNavigationHostingView = AccountNavigationView<AccountNavigationPresenter, AccountNavigationViewFactory>

class AccountNavigationHostingController: UIHostingController<AccountNavigationHostingView> {
    init(presenter: AccountNavigationPresenter) {
        super.init(rootView: .init(presenter: presenter))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
