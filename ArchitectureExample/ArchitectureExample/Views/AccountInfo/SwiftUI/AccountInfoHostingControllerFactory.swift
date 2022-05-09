//
//  AccountInfoHostingControllerFactory.swift
//

extension AccountInfoPresenter: PresenterForAccountInfoView {}

private extension AccountInfoPresenter {
    convenience init?(accountLevelId: AccountLevelId, uiSystem: UISystem) {
        guard let sceneLevel = LevelAccessor.scene(id: accountLevelId.sceneLevelId),
              let accountLevel = LevelAccessor.account(id: accountLevelId),
              LevelAccessor.accountInfo(id: accountLevelId)?.uiSystem == uiSystem else {
                  return nil
              }
        
        self.init(accountLevelId: accountLevelId,
                  accountInteractor: accountLevel.accountInteractor,
                  navigationRouter: accountLevel.navigationRouter,
                  modalRouter: sceneLevel.rootModalRouter)
    }
}

extension AccountInfoHostingController {
    convenience init?(accountLevelId: AccountLevelId) {
        guard let presenter = AccountInfoPresenter(accountLevelId: accountLevelId,
                                                   uiSystem: .swiftUI) else { return nil }
        self.init(presenter: presenter)
    }
}

extension AccountInfoViewController {
    static func instantiate(accountLevelId: AccountLevelId) -> AccountInfoViewController? {
        guard let presenter = AccountInfoPresenter(accountLevelId: accountLevelId,
                                                   uiSystem: .uiKit) else { return nil }
        return AccountInfoViewController.instantiate(presenter: presenter)
    }
}
