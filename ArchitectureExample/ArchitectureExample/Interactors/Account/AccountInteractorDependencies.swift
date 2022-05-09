//
//  AccountInteractorDependencies.swift
//

protocol AccountRepositoryForAccount: AnyObject {
    func account(forId id: Int) -> Account?
    func update(account: Account)
}
