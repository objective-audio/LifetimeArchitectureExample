//
//  AccountPresenter.swift
//

import Foundation

@MainActor
final class AccountMenuPresenter {
    @Published private(set) var title: String = ""

    private weak var accountHolder: AccountHolder?
    private weak var interactor: AccountMenuInteractor?

    init(accountHolder: AccountHolder?,
         interactor: AccountMenuInteractor?) {
        self.accountHolder = accountHolder
        self.interactor = interactor

        accountHolder?.$name.assign(to: &$title)
    }

    let sections: [AccountMenuSection] = [
        .init(kind: .info,
              contents: [.info(.swiftUI), .info(.uiKit)]),
        .init(kind: .logout,
              contents: [.logout])
    ]

    func didSelect(content: AccountMenuContent) {
        switch content {
        case .info(let uiSystem):
            self.interactor?.pushInfo(uiSystem: uiSystem)
        case .logout:
            self.interactor?.logout()
        }
    }
}
