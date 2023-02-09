//
//  AccountDetailPresenter.swift
//

import Foundation

@MainActor
final class AccountDetailPresenter: ObservableObject {
    private weak var interactor: AccountDetailInteractor?

    init(interactor: AccountDetailInteractor) {
        self.interactor = interactor
    }
}
