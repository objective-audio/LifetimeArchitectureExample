//
//  AccountEditPresenter.swift
//

import Combine

@MainActor
final class AccountEditPresenter {
    private weak var interactor: AccountEditInteractor?

    @Published var isSaveButtonDisabled: Bool = true
    @Published var isTextFieldDisabled: Bool = true

    var name: String {
        get { self.interactor?.name ?? "" }
        set { self.interactor?.name = newValue }
    }

    init(interactor: AccountEditInteractor) {
        self.interactor = interactor

        interactor.$isEdited
            .map { !$0 }
            .assign(to: &$isSaveButtonDisabled)

        interactor.$canEdit
            .map { !$0 }
            .assign(to: &$isTextFieldDisabled)
    }

    func commit() {
        self.interactor?.save()
    }

    func cancel() {
        self.interactor?.cancel()
    }
}
