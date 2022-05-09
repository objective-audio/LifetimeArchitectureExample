//
//  AccountInteractor.swift
//

import Combine

@MainActor
final class AccountInteractor {
    let id: Int
    
    @CurrentValue var name: String {
        didSet { self.saveToRepository() }
    }
    
    private weak var accountRepository: AccountRepositoryForAccount?
    
    var namePublisher: AnyPublisher<String, Never> {
        self.$name.eraseToAnyPublisher()
    }
    
    init(id: Int,
         accountRepository: AccountRepositoryForAccount?) {
        self.id = id
        self.name = accountRepository?.account(forId: id)?.name ?? ""
        self.accountRepository = accountRepository
    }
}

extension AccountInteractor {
    var account: Account { .init(id: self.id, name: self.name) }
}

private extension AccountInteractor {
    func saveToRepository() {
        self.accountRepository?.update(account: self.account)
    }
}
