//
//  AccountEditTransitionPresenter.swift
//

import Combine

@MainActor
final class AccountEditTransitionPresenter {
    let accountEditLifetimeId: AccountEditLifetimeId

    private weak var accountEditInteractor: AccountEditInteractor?

    @CurrentValue private(set) var isModalInPresentation: Bool = false

    private var cancellables: Set<AnyCancellable> = .init()

    init(accountEditLifetimeId: AccountEditLifetimeId,
         accountEditInteractor: AccountEditInteractor) {
        self.accountEditLifetimeId = accountEditLifetimeId
        self.accountEditInteractor = accountEditInteractor

        accountEditInteractor.$isEdited
            .assign(to: \.value,
                    on: self.$isModalInPresentation)
            .store(in: &self.cancellables)

    }

    func viewDidDismiss() {
        self.accountEditInteractor?.finalize()

        self.accountEditInteractor = nil
    }
}
