//
//  LoginInteractorDependencies.swift
//

import Combine

protocol RootLevelRouterForLogin: AnyObject {
    var isLoginPublisher: AnyPublisher<Bool, Never> { get }
    func switchToAccount(account: Account)
}

protocol RootModalLevelRouterForLogin: AnyObject {
    func showAlert(content: RootAlertContent)
}

protocol AccountRepositoryForLogin: AnyObject {
    var accounts: [Account] { get }
    func append(account: Account)
}

protocol LoginNetworkForLogin: AnyObject {
    func getAccount(id: String) async -> Result<Account, LoginNetworkError>
}
