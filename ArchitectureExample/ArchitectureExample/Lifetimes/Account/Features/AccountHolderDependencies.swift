//
//  AccountHolderDependencies.swift
//

protocol AccountRepositoryForAccountHolder: AnyObject {
    func account(forId id: Int) -> Account?
    func update(account: Account)
}
