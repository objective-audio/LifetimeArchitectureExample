//
//  RootLevelRouter.swift
//

import Combine

@MainActor
final class RootLevelRouter<Accessor: LevelAccessable> {
    private let sceneLevelId: SceneLevelId
    
    @CurrentValue private(set) var current: RootSubLevel? = nil
    
    init(sceneLevelId: SceneLevelId) {
        self.sceneLevelId = sceneLevelId
    }
    
    func switchToLaunch() {
        guard self.current == nil else {
            assertionFailureIfNotTest()
            return
        }
        
        let level = LaunchLevel(sceneLevelId: self.sceneLevelId,
                                accessor: Accessor.self)
        self.current = .launch(level)
    }
    
    func switchToLogin() {
        switch self.current {
        case .launch, .account:
            let level = LoginLevel(sceneLevelId: self.sceneLevelId,
                                   accessor: Accessor.self)
            self.current = .login(level)
        case .login, .none:
            assertionFailureIfNotTest()
        }
    }
    
    func switchToAccount(account: Account) {
        switch self.current {
        case .launch, .login:
            let level = AccountLevel(accountLevelId: .init(sceneLevelId: self.sceneLevelId,
                                                           accountId: account.id),
                                     accessor: Accessor.self)
            self.current = .account(level)
            level.navigationRouter.pushMenu()
        case .account, .none:
            assertionFailureIfNotTest()
        }
    }
}

extension RootLevelRouter {
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
