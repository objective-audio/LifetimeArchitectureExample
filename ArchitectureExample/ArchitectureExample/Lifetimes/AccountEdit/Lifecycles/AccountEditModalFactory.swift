//
//  AccountEditModalFactory.swift
//

@MainActor
enum AccountEditModalFactory {}

// MARK: -

extension AccountEditModalLifecycle: AccountEditModalLifecycleForAccountEditAlertInteractor {}
extension AccountEditInteractor: AccountEditInteractorForAccountEditAlertInteractor {}
extension AccountEditAlertInteractor: AccountEditAlertInteractorForAccountEditAlertReceiver {}
extension AccountEditAlertLifetime: AccountEditAlertLifetimeForLifecycle {}

extension AccountEditModalFactory {
    static func makeInstanceId() -> InstanceId { .init() }

    static func makeAccountEditAlertLifetime(lifetimeId: AccountEditAlertLifetimeId,
                                             alertId: AccountEditAlertId) -> AccountEditAlertLifetime {
        guard let accountEditLifetime = LifetimeAccessor.accountEdit(id: lifetimeId.accountEdit) else {
            fatalError()
        }

        let interactor = AccountEditAlertInteractor(lifetimeId: lifetimeId,
                                                    alertId: alertId,
                                                    accountEditInteractor: accountEditLifetime.interactor,
                                                    modalLifecycle: accountEditLifetime.modalLifecycle)

        return .init(lifetimeId: lifetimeId,
                     alertId: alertId,
                     interactor: interactor,
                     receiver: .init(accountLifetimeId: lifetimeId.accountEdit.account,
                                     alertId: alertId,
                                     interactor: interactor))
    }

}
