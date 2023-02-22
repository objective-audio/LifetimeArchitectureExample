//
//  AccountDetailPresenter.swift
//

import Foundation

@MainActor
final class AccountDetailPresenter {
    private weak var interactor: AccountDetailInteractor?

    init(interactor: AccountDetailInteractor) {
        self.interactor = interactor
    }
}

extension AccountDetailPresenter: PresenterForAccountDetailView {}
