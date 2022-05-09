//
//  LoginLifetime.swift
//

/**
 ログイン画面の生存期間で必要な機能を保持する
 */

struct LoginLifetime {
    let sceneLifetimeId: SceneLifetimeId
    let network: LoginNetwork
    let interactor: LoginInteractor
}
