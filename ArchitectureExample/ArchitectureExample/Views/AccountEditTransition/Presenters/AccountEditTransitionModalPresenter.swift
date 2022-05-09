//
//  AccountEditTransitionModalPresenter.swift
//

typealias AccountEditTransitionModalPresenter = ModalPresenter<AccountEditModal>

extension AccountEditModal: ModalConvertible {
    init?(_ subLifetime: AccountEditModalSubLifetime?) {
        switch subLifetime {
        case .alert(let lifetime):
            self = .alert(lifetimeId: lifetime.lifetimeId,
                          alertId: lifetime.alertId)
        case .none:
            return nil
        }
    }
}
