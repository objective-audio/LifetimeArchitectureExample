//
//  AccountEditModalLifecycle+Factory.swift
//

extension AccountEditModalLifecycle: AccountEditAlertInteractor.ModalLifecycle {}
extension AccountEditInteractor: AccountEditAlertInteractor.AccountEditInteractor {}
extension AccountEditAlertInteractor: AccountEditAlertReceiver.Interactor {}

extension AccountEditModalLifecycle {
    static func makeAccountEditAlertLifetime(lifetimeId: AccountEditAlertLifetimeId,
                                             alertId: AccountEditAlertId) -> AccountEditAlertLifetime {
        let accountEditLifetime = Accessor.accountEdit(id: lifetimeId.accountEdit)
        let interactor = AccountEditAlertInteractor(lifetimeId: lifetimeId,
                                                    alertId: alertId,
                                                    accountEditInteractor: accountEditLifetime?.interactor,
                                                    modalLifecycle: accountEditLifetime?.modalLifecycle)

        return .init(lifetimeId: lifetimeId,
                     alertId: alertId,
                     interactor: interactor,
                     receiver: .init(accountLifetimeId: lifetimeId.accountEdit.account,
                                     alertId: alertId,
                                     interactor: interactor))
    }
}
