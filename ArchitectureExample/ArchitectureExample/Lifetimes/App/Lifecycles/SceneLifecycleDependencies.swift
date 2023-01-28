//
//  SceneLifecycleDependencies.swift
//

protocol SceneLifetimeForLifecycle {
    var lifetimeId: SceneLifetimeId { get }
    var rootLifecycle: RootLifecycle<RootFactory> { get }
    var rootModalLifecycle: RootModalLifecycle<RootModalFactory> { get }
}

protocol FactoryForSceneLifecycle {
    associatedtype SceneLifetime: SceneLifetimeForLifecycle

    static func makeSceneLifetime(id: SceneLifetimeId) -> SceneLifetime
}
