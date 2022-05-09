//
//  AccountEditRootViewControllerFactory.swift
//

import Foundation

extension AccountEditRootViewController {
    convenience init?(accountLevelId: AccountLevelId) {
        guard let accountEditLevel = LevelAccessor.accountEdit(id: accountLevelId) else {
            assertionFailure()
            return nil
        }
        
        let presenter = AccountEditRootPresenter(accountLevelId: accountLevelId,
                                                 interactor: accountEditLevel.interactor,
                                                 accountEditModalRouter: accountEditLevel.modalRouter)
        
        self.init(presenter: presenter)
    }
}
