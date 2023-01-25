//
//  AppLifetime.swift
//

import Foundation

/**
 アプリ全体の生存期間で必要な機能を保持する
 */

struct AppLifetime {
    let sceneLifecycle: SceneLifecycle<SceneFactory>
    let userDefaults: UserDefaults
    let accountRepository: AccountRepository
    let actionSender: ActionSender
}
