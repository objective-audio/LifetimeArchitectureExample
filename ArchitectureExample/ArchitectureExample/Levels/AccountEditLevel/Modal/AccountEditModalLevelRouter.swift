//
//  AccountEditModalLevelRouter.swift
//

@MainActor
final class AccountEditModalLevelRouter {
    private let accountLevelId: AccountLevelId
    
    @CurrentValue private(set) var current: AccountEditModalSubLevel? = nil
    
    init(accountLevelId: AccountLevelId) {
        self.accountLevelId = accountLevelId
    }
    
    func showAlert(content: AccountEditAlertContent) {
        guard self.current == nil else {
            assertionFailureIfNotTest()
            return
        }
        
        self.current = .alert(content)
    }
    
    func hideAlert(id: AccountEditAlertContent) {
        guard case .alert(let content) = self.current,
              content == id else {
            assertionFailureIfNotTest()
            return
        }
        
        self.current = nil
    }
}
