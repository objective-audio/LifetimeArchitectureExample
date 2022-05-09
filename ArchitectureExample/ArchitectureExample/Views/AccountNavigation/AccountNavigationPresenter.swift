//
//  AccountNavigationPresenter.swift
//

import Combine

@MainActor
final class AccountNavigationPresenter {
    enum View: Equatable {
        case menu
        case info(UISystem)
    }
    
    let accountLevelId: AccountLevelId
    
    private weak var navigationRouter: AccountNavigationLevelRouter?
    
    @CurrentValue private(set) var views: [View] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(accountLevelId: AccountLevelId,
         navigationRouter: AccountNavigationLevelRouter) {
        self.accountLevelId = accountLevelId
        self.navigationRouter = navigationRouter
        
        navigationRouter.$levels
            .map { $0.map(View.init) }
            .assign(to: \.value,
                    on: self.$views)
            .store(in: &self.cancellables)
    }
}

private extension AccountNavigationPresenter.View {
    init(_ level: AccountNavigationSubLevel) {
        switch level {
        case .menu:
            self = .menu
        case .info(let level):
            self = .info(level.uiSystem)
        }
    }
}
