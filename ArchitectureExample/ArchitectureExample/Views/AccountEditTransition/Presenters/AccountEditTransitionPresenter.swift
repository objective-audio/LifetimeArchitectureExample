//
//  AccountEditTransitionPresenter.swift
//

import Combine

@MainActor
final class AccountEditTransitionPresenter: ObservableObject {
    let accountEditLifetimeId: AccountEditLifetimeId

    private weak var accountEditInteractor: AccountEditInteractor?

    @CurrentValue private(set) var isModalInPresentation: Bool = false
    @Published private(set) var interactiveDismissDisabled: Bool = false

    private var cancellables: Set<AnyCancellable> = .init()

    init(accountEditLifetimeId: AccountEditLifetimeId,
         accountEditInteractor: AccountEditInteractor) {
        self.accountEditLifetimeId = accountEditLifetimeId
        self.accountEditInteractor = accountEditInteractor

        accountEditInteractor.$isEdited
            .assign(to: \.value,
                    on: self.$isModalInPresentation)
            .store(in: &self.cancellables)

        accountEditInteractor.$isEdited
            .assign(to: &$interactiveDismissDisabled)
    }

    func onDisappear() {
        self.accountEditInteractor?.finalize()

        self.accountEditInteractor = nil
    }
}
