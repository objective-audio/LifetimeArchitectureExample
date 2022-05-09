//
//  AccountInfoHostingController.swift
//

import SwiftUI

final class AccountInfoHostingController: UIHostingController<AccountInfoView<AccountInfoSwiftUIPresenter>> {
    private let presenter: AccountInfoSwiftUIPresenter

    init(presenter: AccountInfoSwiftUIPresenter) {
        self.presenter = presenter
        super.init(rootView: .init(presenter: presenter))
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
