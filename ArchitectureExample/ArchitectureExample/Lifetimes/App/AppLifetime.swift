//
//  AppLifetime.swift
//

import Foundation

/**
 アプリ全体の生存期間で必要な機能を保持する
 */

struct AppLifetime<Accessor: LifetimeAccessable> {
    let sceneLifecycle: SceneLifecycle<Accessor>
    let userDefaults: UserDefaults
    let accountRepository: AccountRepository
    let actionSender: ActionSender
}
