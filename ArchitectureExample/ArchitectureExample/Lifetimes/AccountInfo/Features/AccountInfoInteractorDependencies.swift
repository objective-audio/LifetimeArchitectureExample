//
//  AccountInfoInteractorDependencies.swift
//

import Combine

protocol AccountNavigationLifecycleForAccountInfoInteractor: AnyObject {
    func popInfo(lifetimeId: AccountInfoLifetimeId)
}

protocol AccountHolderForAccountInfoInteractor: AnyObject {
    var namePublisher: AnyPublisher<String, Never> { get }
}

protocol RootModalLifecycleForAccountInfoInteractor: AnyObject {
    func addAccountEdit(accountLifetimeId: AccountLifetimeId)
}
