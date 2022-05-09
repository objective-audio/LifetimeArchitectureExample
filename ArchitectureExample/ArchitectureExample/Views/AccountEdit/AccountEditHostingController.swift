//
//  AccountEditHostingController.swift
//

import SwiftUI
import Combine

final class AccountEditHostingController: UIHostingController<AccountEditView<AccountEditPresenter>> {
    init(presenter: AccountEditPresenter) {
        super.init(rootView: .init(presenter: presenter))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
