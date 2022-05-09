//
//  LaunchLifetime.swift
//

/**
 アプリの起動処理の生存期間で必要な機能を保持する
 */

struct LaunchLifetime {
    let sceneLifetimeId: SceneLifetimeId
    let interactor: LaunchInteractor
}
