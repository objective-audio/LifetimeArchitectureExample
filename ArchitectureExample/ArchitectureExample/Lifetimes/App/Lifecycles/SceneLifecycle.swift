//
//  SceneLifecycle.swift
//

/**
 SceneLifetimeを動的に生成・保持・破棄する
 */

@MainActor
final class SceneLifecycle<Factory: FactoryForSceneLifecycle> {
    private(set) var lifetimes: [Factory.SceneLifetime] = []
}

extension SceneLifecycle {
    func lifetime(id: SceneLifetimeId) -> SceneLifetimeForLifecycle? {
        guard let lifetime = self.lifetimes.first(where: { $0.lifetimeId == id }) else {
            assertionFailureIfNotTest()
            return nil
        }
        return lifetime
    }

    func index(of id: SceneLifetimeId) -> Int? {
        guard let index = self.lifetimes.firstIndex(where: { $0.lifetimeId == id }) else {
            assertionFailureIfNotTest()
            return nil
        }
        return index
    }

    func append(id: SceneLifetimeId) {
        guard !self.lifetimes.contains(where: { $0.lifetimeId == id}) else {
            assertionFailureIfNotTest()
            return
        }

        let lifetime = Factory.makeSceneLifetime(id: id)
        self.lifetimes.append(lifetime)
    }

    func remove(id: SceneLifetimeId) {
        guard self.lifetimes.contains(where: { $0.lifetimeId == id }) else {
            assertionFailureIfNotTest()
            return
        }

        self.lifetimes.removeAll { $0.lifetimeId == id }
    }
}
