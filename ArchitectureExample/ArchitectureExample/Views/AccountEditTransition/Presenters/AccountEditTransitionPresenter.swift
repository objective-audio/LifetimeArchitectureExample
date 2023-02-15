//
//  AccountEditTransitionPresenter.swift
//

import Combine

@MainActor
final class AccountEditTransitionPresenter: ObservableObject {
    let accountEditLifetimeId: AccountEditLifetimeId

    private weak var accountEditInteractor: AccountEditInteractor?

    @Published private(set) var interactiveDismissDisabled: Bool = false

    init(accountEditLifetimeId: AccountEditLifetimeId,
         accountEditInteractor: AccountEditInteractor) {
        self.accountEditLifetimeId = accountEditLifetimeId
        self.accountEditInteractor = accountEditInteractor

        accountEditInteractor.$isEdited
            .assign(to: &$interactiveDismissDisabled)
    }

    func onDisappear() {
        self.accountEditInteractor?.finalize()

        self.accountEditInteractor = nil
    }
}
