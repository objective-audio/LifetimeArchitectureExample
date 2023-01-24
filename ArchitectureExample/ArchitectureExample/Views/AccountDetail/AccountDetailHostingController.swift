//
//  AccountDetailHostingController.swift
//

import SwiftUI

final class AccountDetailHostingController: UIHostingController<AccountDetailView> {
    private let presenter: AccountDetailPresenter

    init(presenter: AccountDetailPresenter) {
        self.presenter = presenter
        super.init(rootView: .init())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Localized.accountInfoNavigationTitle.value
    }

    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            self.presenter.viewDidRemoveFromParent()
        }

        super.viewDidDisappear(animated)
    }
}
