//
//  LaunchLevelFactory.swift
//

extension SceneLevelRouter: SceneLevelRouterForLaunch {}
extension RootLevelRouter: RootLevelRouterForLaunch {}
extension AccountRepository: AccountRepositoryForLaunch {}

extension LaunchLevel {
    @MainActor
    init<Accessor: LevelAccessable>(sceneLevelId: SceneLevelId,
                                    accessor: Accessor.Type) {
        let appLevel = Accessor.app
        let sceneLevel = Accessor.scene(id: sceneLevelId)
        self.init(interactor: .init(sceneLevelId: sceneLevelId,
                                    sceneLevelRouter: appLevel?.sceneRouter,
                                    rootLevelRouter: sceneLevel?.rootRouter,
                                    accountRepository: appLevel?.accountRepository))
    }
}
