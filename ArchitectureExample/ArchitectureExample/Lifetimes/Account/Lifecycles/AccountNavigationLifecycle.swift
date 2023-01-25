//
//  AccountNavigationLifecycle.swift
//

/**
 アカウント画面のナビゲーションの要素のLifetimeを動的に生成・保持・破棄する
 */

@MainActor
final class AccountNavigationLifecycle<Factory: FactoryForAccountNavigationLifecycle> {
    private let accountLifetimeId: AccountLifetimeId

    @CurrentValue private(set) var stack: [AccountNavigationSubLifetime<Factory>] = []

    private let idGenerator: InstanceIdGeneratable

    init(accountLifetimeId: AccountLifetimeId,
         idGenerator: InstanceIdGeneratable = InstanceIdGenerator()) {
        self.accountLifetimeId = accountLifetimeId
        self.idGenerator = idGenerator

        let lifetimeId = AccountMenuLifetimeId(instanceId: idGenerator.generate(),
                                               account: accountLifetimeId)
        let lifetime = Factory.makeAccountMenuLifetime(lifetimeId: lifetimeId,
                                                       navigationLifecycle: self)
        self.stack = [.menu(lifetime)]
    }
}

extension AccountNavigationLifecycle {
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
        let lifetime = Factory.makeAccountInfoLifetime(lifetimeId: lifetimeId,
                                                    uiSystem: uiSystem)
        self.stack.append(.info(lifetime))
    }

    func canPopInfo(lifetimeId: AccountInfoLifetimeId) -> Bool {
        guard case .info(let lifetime) = self.stack.last,
              lifetime.lifetimeId == lifetimeId else {
            return false
        }
        return true
    }

    func popInfo(lifetimeId: AccountInfoLifetimeId) {
        guard self.canPopInfo(lifetimeId: lifetimeId) else {
            assertionFailureIfNotTest()
            return
        }

        self.stack.removeLast()
    }

    var canPushDetail: Bool {
        if self.stack.count == 2, case .info = self.stack[1] {
            return true
        } else {
            return false
        }
    }

    func pushDetail() {
        guard self.canPushDetail else {
            assertionFailureIfNotTest()
            return
        }

        let lifetimeId = AccountDetailLifetimeId(instanceId: self.idGenerator.generate(),
                                                 account: self.accountLifetimeId)
        let lifetime = Factory.makeAccountDetailLifetime(lifetimeId: lifetimeId)

        self.stack.append(.detail(lifetime))
    }

    func canPopDetail(lifetimeId: AccountDetailLifetimeId) -> Bool {
        guard case .detail(let lifetime) = self.stack.last,
              lifetime.lifetimeId == lifetimeId else {
            return false
        }
        return true
    }

    func popDetail(lifetimeId: AccountDetailLifetimeId) {
        guard self.canPopDetail(lifetimeId: lifetimeId) else {
            assertionFailureIfNotTest()
            return
        }

        self.stack.removeLast()
    }
}
