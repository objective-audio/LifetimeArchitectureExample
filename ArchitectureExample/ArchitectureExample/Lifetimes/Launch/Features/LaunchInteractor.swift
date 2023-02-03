//
//  LaunchInteractor.swift
//

/**
 アプリの起動処理
 */

@MainActor
final class LaunchInteractor {
    private let sceneLifetimeId: SceneLifetimeId
    private unowned var sceneLifecycle: SceneLifecycleForLaunchInteractor?
    private unowned var rootLifecycle: RootLifecycleForLaunchInteractor?
    private unowned var accountRepository: AccountRepositoryForLaunchInteractor?

    init(sceneLifetimeId: SceneLifetimeId,
         sceneLifecycle: SceneLifecycleForLaunchInteractor,
         rootLifecycle: RootLifecycleForLaunchInteractor,
         accountRepository: AccountRepositoryForLaunchInteractor) {
        self.sceneLifetimeId = sceneLifetimeId
        self.sceneLifecycle = sceneLifecycle
        self.rootLifecycle = rootLifecycle
        self.accountRepository = accountRepository
    }

    func launch() {
        guard let rootLifecycle = self.rootLifecycle,
              rootLifecycle.isLaunch else {
            assertionFailureIfNotTest()
            return
        }

        if let index = self.sceneLifecycle?.index(of: self.sceneLifetimeId),
           let accounts = self.accountRepository?.accounts,
           index < accounts.count {
            rootLifecycle.switchToAccount(account: accounts[index])
        } else {
            rootLifecycle.switchToLogin()
        }

        self.sceneLifecycle = nil
        self.rootLifecycle = nil
        self.accountRepository = nil
    }
}
