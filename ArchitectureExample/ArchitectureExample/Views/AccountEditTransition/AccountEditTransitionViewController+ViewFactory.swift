//
//  AccountEditTransitionViewController+ViewFactory.swift
//

extension AccountEditPresenter: AccountEditView.Presenter {}

extension AccountEditTransitionViewController {
    static func makeAccountEditHostingController(
        accountEditLifetimeId: AccountEditLifetimeId
    ) -> AccountEditHostingController? {
        guard let lifetimeId = LifetimeAccessor.accountEdit(id: accountEditLifetimeId) else {
            assertionFailure()
            return nil
        }

        let presenter = AccountEditPresenter(interactor: lifetimeId.interactor)

        return .init(presenter: presenter)
    }
}
