//
//  SceneLifetime.swift
//

/**
 UISceneの生存期間で必要な機能を保持する
 */

struct SceneLifetime<Accessor: LifetimeAccessable> {
    let lifetimeId: SceneLifetimeId
    let rootLifecycle: RootLifecycle<Accessor>
    let rootModalLifecycle: RootModalLifecycle<Accessor>
}
