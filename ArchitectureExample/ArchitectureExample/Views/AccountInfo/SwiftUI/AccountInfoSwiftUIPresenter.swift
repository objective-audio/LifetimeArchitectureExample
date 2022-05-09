//
//  AccountInfoSwiftUIPresenter.swift
//

import Foundation
import Combine

@MainActor
final class AccountInfoSwiftUIPresenter {
    private weak var interactor: AccountInfoInteractor?
    private let accountId: Int

    @Published private var name: String = ""

    init(interactor: AccountInfoInteractor) {
        self.interactor = interactor
        self.accountId = interactor.accountId

        interactor.namePublisher.assign(to: &$name)
    }

    var contents: [[AccountInfoContent]] {
        return [[.id(self.accountId), .name(self.name)],
                [.edit]]
    }

    func viewDidRemoveFromParent() {
        self.interactor?.finalize()
    }

    func handle(action: AccountInfoAction) {
        switch action {
        case .edit:
            self.interactor?.editAccount()
        }
    }
}
