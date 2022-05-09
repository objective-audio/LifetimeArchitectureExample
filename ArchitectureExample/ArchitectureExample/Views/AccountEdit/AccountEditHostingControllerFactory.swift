//
//  RootViewFactory.swift
//

extension AccountEditPresenter: PresenterForAccountEditView {}

extension AccountEditHostingController {
    convenience init?(accountLevelId: AccountLevelId) {
        guard let accountEditLevel = LevelAccessor.accountEdit(id: accountLevelId) else {
            assertionFailure()
            return nil
        }
        
        let presenter = AccountEditPresenter(accountLevelId: accountLevelId,
                                             interactor: accountEditLevel.interactor)
        
        self.init(presenter: presenter)
    }
}
