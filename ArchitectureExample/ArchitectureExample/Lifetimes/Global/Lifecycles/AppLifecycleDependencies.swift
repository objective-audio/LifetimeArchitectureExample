//
//  AppLifecycleDependencies.swift
//

import Foundation

protocol AppLifetimeForLifecycle {
    var sceneLifecycle: SceneLifecycle<SceneFactory> { get }
    var userDefaults: UserDefaults { get }
    var accountRepository: AccountRepository { get }
    var actionSender: ActionSender { get }
}

protocol FactoryForAppLifecycle {
    associatedtype AppLifetime = AppLifetimeForLifecycle

    static func makeAppLifetime() -> AppLifetime
}
