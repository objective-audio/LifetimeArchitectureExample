//
//  LaunchInteractorDependencies.swift
//

protocol SceneLevelRouterForLaunch: AnyObject {
    func index(of id: SceneLevelId) -> Int?
}

protocol RootLevelRouterForLaunch: AnyObject {
    var isLaunch: Bool { get }
    
    func switchToLogin()
    func switchToAccount(account: Account)
}

protocol AccountRepositoryForLaunch: AnyObject {
    var accounts: [Account] { get }
}
