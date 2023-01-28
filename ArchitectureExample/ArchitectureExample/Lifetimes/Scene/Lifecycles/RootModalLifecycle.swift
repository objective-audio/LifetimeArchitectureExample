//
//  RootModalLifecycle.swift
//

import Combine

/**
 ルートの階層から表示するモーダルのLifetimeを動的に生成・保持・破棄する
 */

@MainActor
final class RootModalLifecycle<Factory: FactoryForRootModalLifecycle> {
    let sceneLifetimeId: SceneLifetimeId

    @CurrentValue private(set) var current: RootModalSubLifetime<Factory>?

    private let idGenerator: InstanceIdGeneratable

    init(sceneLifetimeId: SceneLifetimeId,
         idGenerator: InstanceIdGeneratable = InstanceIdGenerator()) {
        self.sceneLifetimeId = sceneLifetimeId
        self.idGenerator = idGenerator
    }
}

extension RootModalLifecycle {
    var hasCurrentPublisher: AnyPublisher<Bool, Never> {
        self.$current
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    func addAlert(id alertId: RootAlertId) {
        guard self.current == nil else {
            assertionFailureIfNotTest()
            return
        }

        let lifetimeId = RootAlertLifetimeId(instanceId: self.idGenerator.generate(),
                                             scene: self.sceneLifetimeId)
        let lifetime = Factory.makeRootAlertLifetime(lifetimeId: lifetimeId,
                                                  alertId: alertId)
        self.current = .init(.alert(lifetime))
    }

    func removeAlert(lifetimeId: RootAlertLifetimeId) {
        guard let current = self.current,
              case .alert(let lifetime) = current,
              lifetime.lifetimeId == lifetimeId else {
            assertionFailureIfNotTest()
            return
        }

        self.current = nil
    }

    func addAccountEdit(accountLifetimeId: AccountLifetimeId) {
        guard self.current == nil,
              self.sceneLifetimeId == accountLifetimeId.scene else {
            assertionFailureIfNotTest()
            return
        }

        let lifetimeId = AccountEditLifetimeId(instanceId: self.idGenerator.generate(),
                                               account: accountLifetimeId)
        let lifetime = Factory.makeAccountEditLifetime(lifetimeId: lifetimeId)
        self.current = .accountEdit(lifetime)
    }

    func removeAccountEdit(lifetimeId: AccountEditLifetimeId) {
        guard let current = self.current,
              case .accountEdit(let lifetime) = current,
              lifetime.lifetimeId == lifetimeId else {
            assertionFailureIfNotTest()
            return
        }

        self.current = nil
    }
}
