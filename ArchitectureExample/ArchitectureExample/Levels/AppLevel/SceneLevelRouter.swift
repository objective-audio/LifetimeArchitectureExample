//
//  SceneLevelRouter.swift
//

@MainActor
final class SceneLevelRouter<Accessor: LevelAccessable> {
    private struct Element {
        let identifier: SceneLevelId
        let level: SceneLevel<Accessor>
    }
    
    private var elements: [Element] = []
    
    func level(id: SceneLevelId) -> SceneLevel<Accessor>? {
        guard let level = self.elements.first(where: { $0.identifier == id })?.level else {
            assertionFailureIfNotTest()
            return nil
        }
        return level
    }
    
    func index(of id: SceneLevelId) -> Int? {
        guard let index = self.elements.firstIndex(where: { $0.identifier == id }) else {
            assertionFailureIfNotTest()
            return nil
        }
        return index
    }
    
    func append(id: SceneLevelId) {
        guard !self.elements.contains(where: { $0.identifier == id}) else {
            assertionFailureIfNotTest()
            return
        }
        
        let sceneLevel = SceneLevel<Accessor>(sceneLevelId: id)
        self.elements.append(.init(identifier: id, level: sceneLevel))
        sceneLevel.rootRouter.switchToLaunch()
    }
    
    func remove(id: SceneLevelId) {
        guard self.elements.contains(where: { $0.identifier == id }) else {
            assertionFailureIfNotTest()
            return
        }
        
        self.elements.removeAll { $0.identifier == id }
    }
}

extension SceneLevel {
    @MainActor
    init(sceneLevelId: SceneLevelId) {
        self.rootRouter = .init(sceneLevelId: sceneLevelId)
        self.rootModalRouter = .init(sceneLevelId: sceneLevelId)
    }
}
