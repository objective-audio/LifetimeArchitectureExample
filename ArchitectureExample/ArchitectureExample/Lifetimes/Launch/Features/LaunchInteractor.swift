//
//  LaunchInteractor.swift
//

/**
 アプリの起動処理
 */

@MainActor
final class LaunchInteractor {
    typealias SceneLifecycle = SceneLifecycleForLaunchInteractor
    typealias RootLifecycle = RootLifecycleForLaunchInteractor
    typealias AccountRepository = AccountRepositoryForLaunchInteractor

    private let sceneLifetimeId: SceneLifetimeId
    private unowned var sceneLifecycle: SceneLifecycle?
    private unowned var rootLifecycle: RootLifecycle?
    private unowned var accountRepository: AccountRepository?

    init(sceneLifetimeId: SceneLifetimeId,
         sceneLifecycle: SceneLifecycle,
         rootLifecycle: RootLifecycle,
         accountRepository: AccountRepository) {
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
