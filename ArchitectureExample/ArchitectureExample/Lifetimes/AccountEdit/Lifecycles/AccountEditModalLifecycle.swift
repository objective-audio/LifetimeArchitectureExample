//
//  AccountEditModalLifecycle.swift
//

import Combine

/**
 アカウント編集の階層から表示するモーダルのLifetimeを動的に生成・保持・破棄する
 */

@MainActor
final class AccountEditModalLifecycle<Accessor: LifetimeAccessable> {
    let lifetimeId: AccountEditLifetimeId

    @CurrentValue private(set) var current: AccountEditModalSubLifetime?

    private let idGenerator: InstanceIdGeneratable

    init(lifetimeId: AccountEditLifetimeId,
         idGenerator: InstanceIdGeneratable = InstanceIdGenerator()) {
        self.lifetimeId = lifetimeId
        self.idGenerator = idGenerator
    }
}

extension AccountEditModalLifecycle {
    var hasCurrentPublisher: AnyPublisher<Bool, Never> {
        self.$current
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    func addAlert(id alertId: AccountEditAlertId) {
        guard self.current == nil else {
            assertionFailureIfNotTest()
            return
        }

        let lifetimeId = AccountEditAlertLifetimeId(instanceId: self.idGenerator.generate(),
                                                    accountEdit: self.lifetimeId)
        let lifetime = Self.makeAccountEditAlertLifetime(lifetimeId: lifetimeId,
                                                         alertId: alertId)
        self.current = .init(.alert(lifetime))
    }

    func removeAlert(lifetimeId: AccountEditAlertLifetimeId) {
        guard let current = self.current,
              case .alert(let lifetime) = current,
              lifetime.lifetimeId == lifetimeId else {
            assertionFailureIfNotTest()
            return
        }

        self.current = nil
    }
}
