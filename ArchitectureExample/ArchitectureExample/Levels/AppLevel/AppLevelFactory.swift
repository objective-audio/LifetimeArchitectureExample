//
//  AppLevelFactory.swift
//

import Foundation

extension AppLevel {
    @MainActor
    init() {
        let userDefaults = UserDefaults.standard
        
        self.init(sceneRouter: .init(),
                  userDefaults: userDefaults,
                  accountRepository: .init(userDefaults: userDefaults))
    }
}
