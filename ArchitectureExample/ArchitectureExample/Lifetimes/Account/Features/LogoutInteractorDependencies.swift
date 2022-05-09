//
//  LogoutInteractorDependencies.swift
//

protocol AccountRepositoryForLogoutInteractor: AnyObject {
    func remove(accountId: Int)
}

protocol RootLifecycleForLogoutInteractor: AnyObject {
    func switchToLogin()
}
