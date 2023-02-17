//
//  AccountEditTransitionViewFactory.swift
//

@MainActor
struct AccountEditTransitionViewFactory {}

// MARK: -

extension AccountEditPresenter: PresenterForAccountEditView {}

extension AccountEditTransitionViewFactory: FactoryForAccountEditTransitionView {
    func makeAccountEditPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditPresenter? {
        guard let lifetime = LifetimeAccessor.accountEdit(id: lifetimeId) else {
            // AccountEditのSheetを閉じる時にViewが更新され呼ばれることがあるのでAssertしない
            return nil
        }

        return .init(interactor: lifetime.interactor)
    }

    func makeAlertPresenter(
        lifetimeId: AccountEditAlertLifetimeId?
    ) -> AccountEditAlertPresenter? {
        guard let lifetimeId else { return nil }

        guard let lifetime = LifetimeAccessor.accountEditAlert(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(interactor: lifetime.interactor)
    }
}
