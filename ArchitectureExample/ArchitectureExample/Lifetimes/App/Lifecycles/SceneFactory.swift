//
//  SceneFactory.swift
//

extension SceneLifetime: SceneLifetimeForLifecycle {}
extension RootFactory: FactoryForRootLifecycle {}
extension RootModalFactory: FactoryForRootModalLifecycle {}

@MainActor
struct SceneFactory {}

extension SceneFactory {
    static func makeSceneLifetime(id: SceneLifetimeId) -> SceneLifetime {
        let lifecycle = RootModalLifecycle<RootModalFactory>(sceneLifetimeId: id)

        return .init(lifetimeId: id,
                     rootLifecycle: .init(sceneLifetimeId: id),
                     rootModalLifecycle: lifecycle)
    }
}
