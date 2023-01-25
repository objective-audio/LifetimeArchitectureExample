//
//  RootLifecycle.swift
//

import Combine

/**
 ルートの階層で切り替えて表示するLifetimeを動的に生成・保持・破棄する
 */

@MainActor
final class RootLifecycle<Factory: FactoryForRootLifecycle> {
    let sceneLifetimeId: SceneLifetimeId

    @CurrentValue private(set) var current: RootSubLifetime<Factory>?

    init(sceneLifetimeId: SceneLifetimeId) {
        self.sceneLifetimeId = sceneLifetimeId

        let lifetime = Factory.makeLaunchLifetime(sceneLifetimeId: self.sceneLifetimeId, rootLifecycle: self)
        self.current = .launch(lifetime)
    }
}

extension RootLifecycle {
    func switchToLogin() {
        switch self.current {
        case .launch, .account:
            let lifetime = Factory.makeLoginLifetime(sceneLifetimeId: self.sceneLifetimeId)
            self.current = .login(lifetime)
        case .login, .none:
            assertionFailureIfNotTest()
        }
    }

    func switchToAccount(account: Account) {
        switch self.current {
        case .launch, .login:
            let lifetime = Factory.makeAccountLifetime(id: .init(scene: self.sceneLifetimeId,
                                                              accountId: account.id))
            self.current = .account(lifetime)
        case .account, .none:
            assertionFailureIfNotTest()
        }
    }
}

extension RootLifecycle {
    var isLaunch: Bool {
        guard case .launch = self.current else { return false }
        return true
    }

    var isLoginPublisher: AnyPublisher<Bool, Never> {
        self.$current.map {
            guard case .login = $0 else { return false }
            return true
        }.eraseToAnyPublisher()
    }
}
