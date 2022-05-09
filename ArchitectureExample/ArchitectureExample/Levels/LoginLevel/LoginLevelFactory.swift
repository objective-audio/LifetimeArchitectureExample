//
//  LoginLevelFactory.swift
//

extension RootLevelRouter: RootLevelRouterForLogin {}
extension RootModalLevelRouter: RootModalLevelRouterForLogin {}
extension AccountRepository: AccountRepositoryForLogin {}
extension LoginNetwork: LoginNetworkForLogin {}

extension LoginLevel {
    @MainActor
    init<Accessor: LevelAccessable>(sceneLevelId: SceneLevelId,
                                    accessor: Accessor.Type) {
        let appLevel = Accessor.app
        let sceneLevel = Accessor.scene(id: sceneLevelId)
        let network = LoginNetwork()
        let interactor = LoginInteractor(sceneLevelId: sceneLevelId,
                                         rootLevelRouter: sceneLevel?.rootRouter,
                                         rootModalLevelRouter: sceneLevel?.rootModalRouter,
                                         accountRepository: appLevel?.accountRepository,
                                         network: network)
        
        self.init(network: network,
                  interactor: interactor)
    }
}
