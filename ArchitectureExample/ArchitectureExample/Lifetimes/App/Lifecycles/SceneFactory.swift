//
//  SceneFactory.swift
//

@MainActor
enum SceneFactory {}

// MARK: -

extension SceneLifetime: SceneLifetimeForLifecycle {}
extension RootFactory: FactoryForRootLifecycle {}
extension RootModalFactory: FactoryForRootModalLifecycle {}

extension SceneFactory {
    static func makeSceneLifetime(id: SceneLifetimeId) -> SceneLifetime {
        let lifecycle = RootModalLifecycle<RootModalFactory>(sceneLifetimeId: id)

        return .init(lifetimeId: id,
                     rootLifecycle: .init(sceneLifetimeId: id),
                     rootModalLifecycle: lifecycle)
    }
}
