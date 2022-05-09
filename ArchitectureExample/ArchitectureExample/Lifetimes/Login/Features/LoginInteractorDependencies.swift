//
//  LoginInteractorDependencies.swift
//

import Combine

protocol RootLifecycleForLoginInteractor: AnyObject {
    var isLoginPublisher: AnyPublisher<Bool, Never> { get }
    func switchToAccount(account: Account)
}

protocol RootModalLifecycleForLoginInteractor: AnyObject {
    var hasCurrentPublisher: AnyPublisher<Bool, Never> { get }
    func addAlert(id: RootAlertId)
}

protocol AccountRepositoryForLoginInteractor: AnyObject {
    var accounts: [Account] { get }
    func append(account: Account)
}

protocol LoginNetworkForLoginInteractor: AnyObject {
    func getAccount(id: String) async -> Result<Account, LoginNetworkError>
}
