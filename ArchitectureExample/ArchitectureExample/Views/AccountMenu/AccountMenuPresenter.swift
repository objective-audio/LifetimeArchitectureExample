//
//  AccountPresenter.swift
//

import Foundation

@MainActor
final class AccountMenuPresenter {
    @Published private(set) var title: String = ""
    
    private weak var accountInteractor: AccountInteractor?
    private weak var logoutInteractor: LogoutInteractor?
    private weak var router: AccountNavigationLevelRouter?
    
    init(accountInteractor: AccountInteractor?,
         logoutInteractor: LogoutInteractor?,
         router: AccountNavigationLevelRouter?) {
        self.accountInteractor = accountInteractor
        self.logoutInteractor = logoutInteractor
        self.router = router
        
        accountInteractor?.$name.assign(to: &$title)
    }
    
    let sections: [AccountMenuSection] = [
        .init(kind: .info,
              contents: [.info(.swiftUI), .info(.uiKit)]),
        .init(kind: .logout,
              contents: [.logout])
    ]
    
    func didSelect(content: AccountMenuContent) {
        switch content {
        case .info(let uiSystem):
            self.router?.pushInfo(uiSystem: uiSystem)
        case .logout:
            self.logoutInteractor?.logout()
        }
    }
    
    func logout() {
        self.logoutInteractor?.logout()
    }
}
