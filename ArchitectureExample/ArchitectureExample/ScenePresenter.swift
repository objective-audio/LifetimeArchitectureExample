//
//  ScenePresenter.swift
//

@MainActor
final class ScenePresenter {
    private weak var router: SceneLevelRouter<LevelAccessor>?
    
    init(router: SceneLevelRouter<LevelAccessor>) {
        self.router = router
    }
    
    func willConnect(id: SceneLevelId) {
        self.router?.append(id: id)
    }
    
    func didConnect(id: SceneLevelId) {
        self.router?.remove(id: id)
    }
}
