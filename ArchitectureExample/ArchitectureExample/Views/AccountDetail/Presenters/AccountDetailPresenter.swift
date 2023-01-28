//
//  AccountDetailPresenter.swift
//

@MainActor
final class AccountDetailPresenter {
    private weak var interactor: AccountDetailInteractor?

    init(interactor: AccountDetailInteractor) {
        self.interactor = interactor
    }

    func viewDidRemoveFromParent() {
        self.interactor?.finalize()
    }
}
