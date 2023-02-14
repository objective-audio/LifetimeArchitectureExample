//
//  AccountEditTransitionViewFactory.swift
//

@MainActor
enum AccountEditTransitionViewFactory {}

// MARK: -

extension AccountEditPresenter: PresenterForAccountEditView {}

extension AccountEditTransitionViewFactory: FactoryForAccountEditTransitionView {
    static func makeAccountEditPresenter(
        accountEditLifetimeId: AccountEditLifetimeId
    ) -> AccountEditPresenter? {
        guard let lifetime = LifetimeAccessor.accountEdit(id: accountEditLifetimeId) else {
            // AccountEditのSheetを閉じる時にViewが更新され呼ばれることがあるのでAssertしない
            return nil
        }

        return .init(interactor: lifetime.interactor)
    }

    static func makeAlertPresenter(
        accountEditAlertLifetimeId: AccountEditAlertLifetimeId
    ) -> AccountEditAlertPresenter? {
        guard let lifetime = LifetimeAccessor.accountEditAlert(id: accountEditAlertLifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(interactor: lifetime.interactor)
    }
}
