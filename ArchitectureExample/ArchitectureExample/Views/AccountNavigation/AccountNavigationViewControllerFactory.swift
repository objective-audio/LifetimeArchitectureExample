//
//  AccountNavigationViewControllerFactory.swift
//

extension AccountNavigationViewController {
    static func instantiate(accountLevelId: AccountLevelId) -> AccountNavigationViewController? {
        guard let level = LevelAccessor.account(id: accountLevelId) else { return nil }
        let presenter = AccountNavigationPresenter(accountLevelId: accountLevelId,
                                                   navigationRouter: level.navigationRouter)
        return self.instantiate(presenter: presenter)
    }
}
