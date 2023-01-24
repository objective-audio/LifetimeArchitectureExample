//
//  AccountInfoUIKitPresenter.swift
//

import Foundation
import Combine

@MainActor
final class AccountInfoUIKitPresenter {
    private weak var interactor: AccountInfoInteractor?
    private let accountId: Int

    @CurrentValue private(set) var name: String = ""

    private var cancellables: Set<AnyCancellable> = .init()

    init(interactor: AccountInfoInteractor) {
        self.interactor = interactor
        self.accountId = interactor.accountId

        interactor.namePublisher
            .assign(to: \.value,
                    on: self.$name)
            .store(in: &self.cancellables)
    }

    let contentIds: [[AccountInfoContentID]] = [[.id, .name],
                                                [.edit],
                                                [.pushDetail]]

    func content(for contentId: AccountInfoContentID) -> AccountInfoContent {
        switch contentId {
        case .id:
            return .id(self.accountId)
        case .name:
            return .name(self.name)
        case .edit:
            return .edit
        case .pushDetail:
            return .pushDetail
        }
    }

    func viewDidRemoveFromParent() {
        self.interactor?.finalize()
    }

    func didSelect(contentId: AccountInfoContentID) {
        switch self.content(for: contentId).action {
        case .edit:
            self.interactor?.editAccount()
        case .pushDetail:
            self.interactor?.pushDetail()
        case .none:
            break
        }
    }
}
