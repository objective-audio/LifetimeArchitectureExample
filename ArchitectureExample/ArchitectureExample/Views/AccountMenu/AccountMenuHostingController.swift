//
//  AccountMenuHostingController.swift
//

import SwiftUI

final class AccountMenuHostingController: UIHostingController<AccountMenuView<AccountMenuPresenter>> {
    init(presenter: AccountMenuPresenter) {
        super.init(rootView: .init(presenter: presenter))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
