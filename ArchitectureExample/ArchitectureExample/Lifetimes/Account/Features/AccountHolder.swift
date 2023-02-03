//
//  AccountHolder.swift
//

import Combine

/**
 アカウント情報を保持する
 nameは変更可能で通知と永続化をする
 */

@MainActor
final class AccountHolder {
    let id: Int

    @CurrentValue var name: String {
        didSet { self.saveToRepository() }
    }

    private unowned var repository: AccountRepositoryForAccountHolder

    init(id: Int,
         accountRepository: AccountRepositoryForAccountHolder) {
        self.id = id
        self.name = accountRepository.account(forId: id)?.name ?? ""
        self.repository = accountRepository
    }
}

extension AccountHolder {
    var namePublisher: AnyPublisher<String, Never> { self.$name.eraseToAnyPublisher() }
    var account: Account { .init(id: self.id, name: self.name) }
}

private extension AccountHolder {
    func saveToRepository() {
        self.repository.update(account: self.account)
    }
}
