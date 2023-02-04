//
//  AppFactory.swift
//

import Foundation

@MainActor
enum AppFactory {}

// MARK: -

extension AppLifetime: AppLifetimeForLifecycle {}
extension SceneFactory: FactoryForSceneLifecycle {}

extension AppFactory {
    static func makeAppLifetime() -> AppLifetime {
        let sceneLifecycle = SceneLifecycle<SceneFactory>()
        let userDefaults = UserDefaults.standard

        return .init(sceneLifecycle: sceneLifecycle,
                     userDefaults: userDefaults,
                     accountRepository: .init(userDefaults: userDefaults),
                     actionSender: .init(rootProvider: sceneLifecycle))
    }
}
