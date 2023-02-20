//
//  AccountEditModalLifecycle.swift
//

import Combine

/**
 アカウント編集の階層から表示するモーダルのLifetimeを動的に生成・保持・破棄する
 */

@MainActor
final class AccountEditModalLifecycle<Factory: FactoryForAccountEditModalLifecycle> {
    let lifetimeId: AccountEditLifetimeId

    @CurrentValue private(set) var current: AccountEditModalSubLifetime<Factory>?

    init(lifetimeId: AccountEditLifetimeId,
         factory: Factory.Type) {
        self.lifetimeId = lifetimeId
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

        let lifetimeId = AccountEditAlertLifetimeId(instanceId: Factory.makeInstanceId(),
                                                    accountEdit: self.lifetimeId)
        let lifetime = Factory.makeAccountEditAlertLifetime(lifetimeId: lifetimeId,
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
