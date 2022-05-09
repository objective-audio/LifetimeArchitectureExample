//
//  RootModalFactory.swift
//

extension AccountInteractor: AccountInteractorForAccountEdit {}
extension RootModalLevelRouter: RootModalLevelRouterForAccountEdit {}
extension AccountEditModalLevelRouter: AccountEditModalLevelRouterForAccountEdit {}

extension AccountEditLevel {
    @MainActor
    init<Accessor: LevelAccessable>(accountLevelId: AccountLevelId,
                                    accessor: Accessor.Type) {
        let sceneLevel = Accessor.scene(id: accountLevelId.sceneLevelId)
        let accountLevel = Accessor.account(id: accountLevelId)
        
        let modalRouter = AccountEditModalLevelRouter(accountLevelId: accountLevelId)
        let interactor = AccountEditInteractor(accountLevelId: accountLevelId,
                                               accountInteractor: accountLevel?.accountInteractor,
                                               rootModalRouter: sceneLevel?.rootModalRouter,
                                               accountEditModalRouter: modalRouter)
        
        self.init(interactor: interactor,
                  modalRouter: modalRouter)
    }
}
