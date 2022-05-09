//
//  AppLifecycle+Factory.swift
//

import Foundation

extension AppLifecycle {
    static func makeAppLifetime() -> AppLifetime<Accessor> {
        let sceneLifecycle = SceneLifecycle<Accessor>()
        let userDefaults = UserDefaults.standard

        return .init(sceneLifecycle: sceneLifecycle,
                     userDefaults: userDefaults,
                     accountRepository: .init(userDefaults: userDefaults),
                     actionSender: .init(rootProvider: sceneLifecycle))
    }
}
