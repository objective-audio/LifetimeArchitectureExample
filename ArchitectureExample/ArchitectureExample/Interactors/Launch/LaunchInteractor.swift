//
//  LaunchInteractor.swift
//

@MainActor
final class LaunchInteractor {
    private let sceneLevelId: SceneLevelId
    private weak var sceneLevelRouter: SceneLevelRouterForLaunch?
    private weak var rootLevelRouter: RootLevelRouterForLaunch?
    private weak var accountRepository: AccountRepositoryForLaunch?
    
    init(sceneLevelId: SceneLevelId,
         sceneLevelRouter: SceneLevelRouterForLaunch?,
         rootLevelRouter: RootLevelRouterForLaunch?,
         accountRepository: AccountRepositoryForLaunch?) {
        self.sceneLevelId = sceneLevelId
        self.sceneLevelRouter = sceneLevelRouter
        self.rootLevelRouter = rootLevelRouter
        self.accountRepository = accountRepository
    }
    
    func launch() {
        guard let rootRouter = self.rootLevelRouter,
              rootRouter.isLaunch else {
            assertionFailureIfNotTest()
            return
        }
        
        if let index = self.sceneLevelRouter?.index(of: self.sceneLevelId),
           let accounts = self.accountRepository?.accounts,
           index < accounts.count {
            rootRouter.switchToAccount(account: accounts[index])
        } else {
            rootRouter.switchToLogin()
        }
        
        self.sceneLevelRouter = nil
        self.rootLevelRouter = nil
        self.accountRepository = nil
    }
}
