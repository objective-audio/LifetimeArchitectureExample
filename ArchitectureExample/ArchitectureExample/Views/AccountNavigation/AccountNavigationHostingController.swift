//
//  AccountNavigationHostingController.swift
//

import SwiftUI

typealias AccountNavigationHostingView = AccountNavigationView<AccountNavigationPresenter, AccountNavigationViewFactory>

final class AccountNavigationHostingController: UIHostingController<AccountNavigationHostingView> {
    init(presenter: AccountNavigationPresenter,
         factory: AccountNavigationViewFactory) {
        super.init(rootView: .init(presenter: presenter,
                                   factory: factory))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
