//
//  LogoutInteractorDependencies.swift
//

protocol AccountRepositoryForLogout: AnyObject {
    func remove(accountId: Int)
}

protocol RootLevelRouterForLogout: AnyObject {
    func switchToLogin()
}
