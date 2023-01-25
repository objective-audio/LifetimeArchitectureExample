//
//  SceneLifetime.swift
//

/**
 UISceneの生存期間で必要な機能を保持する
 */

struct SceneLifetime {
    let lifetimeId: SceneLifetimeId
    let rootLifecycle: RootLifecycle<RootFactory>
    let rootModalLifecycle: RootModalLifecycle<RootModalFactory>
}
