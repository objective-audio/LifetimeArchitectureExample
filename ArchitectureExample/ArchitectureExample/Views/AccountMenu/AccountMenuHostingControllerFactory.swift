//
//  AccountMenuHostingControllerFactory.swift
//

extension AccountMenuPresenter: PresenterForAccountMenuView {}

extension AccountMenuHostingController {
    convenience init?(accountLevelId: AccountLevelId) {
        guard let level = LevelAccessor.account(id: accountLevelId),
              LevelAccessor.accountMenu(id: accountLevelId) != nil else { return nil }
        
        let presenter = AccountMenuPresenter(accountInteractor: level.accountInteractor,
                                             logoutInteractor: level.logoutInteractor,
                                             router: level.navigationRouter)
        
        self.init(presenter: presenter)
    }
}
