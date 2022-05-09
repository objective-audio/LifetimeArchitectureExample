//
//  AccountEditInteractorDependencies.swift
//

import Combine

protocol AccountHolderForAccountEditInteractor: AnyObject {
    var name: String { get set }
}

protocol RootModalLifecycleForAccountEditInteractor: AnyObject {
    func removeAccountEdit(lifetimeId: AccountEditLifetimeId)
}

protocol AccountEditModalLifecycleForAccountEditInteractor: AnyObject {
    var hasCurrentPublisher: AnyPublisher<Bool, Never> { get }
    func addAlert(id: AccountEditAlertId)
}

protocol ActionSenderForAccountEditInteractor: AnyObject {
    func sendLogout(accountLifetimeId: AccountLifetimeId)
}
