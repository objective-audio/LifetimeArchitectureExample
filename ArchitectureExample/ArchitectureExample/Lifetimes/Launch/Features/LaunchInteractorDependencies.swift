//
//  LaunchInteractorDependencies.swift
//

protocol SceneLifecycleForLaunchInteractor: AnyObject {
    func index(of id: SceneLifetimeId) -> Int?
}

protocol RootLifecycleForLaunchInteractor: AnyObject {
    var isLaunch: Bool { get }

    func switchToLogin()
    func switchToAccount(account: Account)
}

protocol AccountRepositoryForLaunchInteractor: AnyObject {
    var accounts: [Account] { get }
}
