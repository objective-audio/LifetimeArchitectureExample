//
//  GlobalActionId.swift
//

/**
 Lifetimeのヒエラルキー全体を通して送るActionのID
 */

struct GlobalActionId {
    let sceneLifetimeId: SceneLifetimeId
    let accountId: Int?

    // テスト用にテストターゲット側でEquatableに適合させている
}

extension GlobalActionId {
    init(sceneLifetimeId: SceneLifetimeId) {
        self.sceneLifetimeId = sceneLifetimeId
        self.accountId = nil
    }

    init(accountLifetimeId: AccountLifetimeId) {
        self.sceneLifetimeId = accountLifetimeId.scene
        self.accountId = accountLifetimeId.accountId
    }
}

extension GlobalActionId? {
    func isMatch(_ other: GlobalActionId?) -> Bool {
        guard let rhs = other, let lhs = self else {
            return true
        }

        if lhs.sceneLifetimeId != rhs.sceneLifetimeId {
            return false
        }

        if let lhsAccountId = lhs.accountId,
           let rhsAccountId = rhs.accountId {
            return lhsAccountId == rhsAccountId
        }

        return true
    }
}
