//
//  AccountNavigationLifecycle.swift
//

/**
 アカウント画面のナビゲーションの要素のLifetimeを動的に生成・保持・破棄する
 */

@MainActor
final class AccountNavigationLifecycle<Accessor: LifetimeAccessable> {
    private let accountLifetimeId: AccountLifetimeId

    @CurrentValue private(set) var stack: [AccountNavigationSubLifetime] = []

    private let idGenerator: InstanceIdGeneratable

    init(accountLifetimeId: AccountLifetimeId,
         idGenerator: InstanceIdGeneratable = InstanceIdGenerator()) {
        self.accountLifetimeId = accountLifetimeId
        self.idGenerator = idGenerator
    }
}

extension AccountNavigationLifecycle {
    func pushMenu() {
        guard self.stack.isEmpty else {
            assertionFailureIfNotTest()
            return
        }

        let lifetimeId = AccountMenuLifetimeId(instanceId: self.idGenerator.generate(),
                                               account: self.accountLifetimeId)
        let lifetime = Self.makeAccountMenuLifetime(lifetimeId: lifetimeId)
        self.stack.append(.menu(lifetime))
    }

    var canPushInfo: Bool {
        if self.stack.count == 1, case .menu = self.stack[0] {
            return true
        } else {
            return false
        }
    }

    func pushInfo(uiSystem: UISystem) {
        guard self.canPushInfo else {
            assertionFailureIfNotTest()
            return
        }

        let lifetimeId = AccountInfoLifetimeId(instanceId: self.idGenerator.generate(),
                                               account: self.accountLifetimeId)
        let lifetime = Self.makeAccountInfoLifetime(lifetimeId: lifetimeId,
                                                    uiSystem: uiSystem)
        self.stack.append(.info(lifetime))
    }

    func popInfo(lifetimeId: AccountInfoLifetimeId) {
        guard case .info(let lifetime) = self.stack.last,
              lifetime.lifetimeId == lifetimeId else {
            assertionFailureIfNotTest()
            return
        }

        self.stack.removeLast()
    }
}
