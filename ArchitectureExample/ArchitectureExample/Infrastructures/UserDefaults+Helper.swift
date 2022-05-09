//
//  UserDefaults+Helper.swift
//

import Foundation

extension UserDefaults {
    var accounts: [[String: Any]] {
        get { self.array(forKey: Key.accounts) as? [[String: Any]] ?? [] }
        set { self.set(newValue, forKey: Key.accounts) }
    }
}

private extension UserDefaults {
    enum Key {
        static let accounts = "accounts"
    }
}
