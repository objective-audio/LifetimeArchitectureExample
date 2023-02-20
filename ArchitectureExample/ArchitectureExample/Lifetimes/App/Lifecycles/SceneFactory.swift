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
        let lifecycle = RootModalLifecycle(sceneLifetimeId: id,
                                           factory: RootModalFactory.self)

        return .init(lifetimeId: id,
                     rootLifecycle: .init(sceneLifetimeId: id,
                                          factory: RootFactory.self),
                     rootModalLifecycle: lifecycle)
    }
}
