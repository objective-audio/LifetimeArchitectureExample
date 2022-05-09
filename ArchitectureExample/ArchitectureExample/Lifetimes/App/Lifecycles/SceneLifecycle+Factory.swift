//
//  SceneLifecycle+Factory.swift
//

import Foundation

extension SceneLifecycle {
    static func makeSceneLifetime(id: SceneLifetimeId) -> SceneLifetime<Accessor> {
        let lifecycle = RootModalLifecycle<Accessor>(sceneLifetimeId: id)

        return .init(lifetimeId: id,
                     rootLifecycle: .init(sceneLifetimeId: id),
                     rootModalLifecycle: lifecycle)
    }
}
