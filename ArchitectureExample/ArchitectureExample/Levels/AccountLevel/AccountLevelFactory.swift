//
//  AccountLevelFactory.swift
//

extension RootLevelRouter: RootLevelRouterForLogout {}
extension AccountRepository: AccountRepositoryForLogout {}
extension AccountRepository: AccountRepositoryForAccount {}

extension AccountLevel {
    @MainActor
    init<Accessor: LevelAccessable>(accountLevelId: AccountLevelId,
                                    accessor: Accessor.Type) {
        let appLevel = Accessor.app
        let sceneLevel = Accessor.scene(id: accountLevelId.sceneLevelId)
        let accountId = accountLevelId.accountId
        
        self.init(accountInteractor: .init(id: accountId,
                                           accountRepository: appLevel?.accountRepository),
                  logoutInteractor: .init(accountId: accountId,
                                          rootLevelRouter: sceneLevel?.rootRouter,
                                          accountRepository: appLevel?.accountRepository),
                  navigationRouter: .init())
    }
}
