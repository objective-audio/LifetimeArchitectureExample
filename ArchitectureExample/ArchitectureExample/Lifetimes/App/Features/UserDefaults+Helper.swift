//
//  UserDefaults+Helper.swift
//

import Foundation

/**
 UserDefaultsの値の取得・保存で最低限の型をつける
 アプリで扱うための型との変換はRepositoryに任せる
 */

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
