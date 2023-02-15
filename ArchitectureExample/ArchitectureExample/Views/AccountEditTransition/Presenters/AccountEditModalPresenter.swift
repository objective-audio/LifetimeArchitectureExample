//
//  AccountEditModalPresenter.swift
//

import Foundation

@MainActor
final class AccountEditModalPresenter: ObservableObject {
    private weak var lifecycle: AccountEditModalLifecycle<AccountEditModalFactory>?

    // Alertは必ず何かしらのアクションを受けて閉じるのでfalseがセットされても無視する
    @Published var isDestructAlertPresented: Bool = false
    @Published var isLogoutAlertPresented: Bool = false

    var modal: AccountEditModal? { .init(self.lifecycle?.current) }

    init(lifecycle: AccountEditModalLifecycle<AccountEditModalFactory>) {
        self.lifecycle = lifecycle

        lifecycle
            .$current
            .map(AccountEditDestructAlert.init)
            .map { $0 != nil }
            .assign(to: &$isDestructAlertPresented)

        lifecycle
            .$current
            .map(AccountEditLogoutAlert.init)
            .map { $0 != nil }
            .assign(to: &$isLogoutAlertPresented)
    }
}

extension AccountEditModal {
    init?(_ subLifetime: AccountEditModalSubLifetime<AccountEditModalFactory>?) {
        switch subLifetime {
        case .alert(let lifetime):
            self = .alert(lifetimeId: lifetime.lifetimeId,
                          alertId: lifetime.alertId)
        case .none:
            return nil
        }
    }
}

extension AccountEditDestructAlert {
    init?(_ subLifetime: AccountEditModalSubLifetime<AccountEditModalFactory>?) {
        switch subLifetime {
        case .alert(let lifetime):
            switch lifetime.alertId {
            case .destruct:
                self = .init(lifetimeId: lifetime.lifetimeId)
            case .logout:
                return nil
            }
        case .none:
            return nil
        }
    }
}

extension AccountEditLogoutAlert {
    init?(_ subLifetime: AccountEditModalSubLifetime<AccountEditModalFactory>?) {
        switch subLifetime {
        case .alert(let lifetime):
            switch lifetime.alertId {
            case .logout:
                self = .init(lifetimeId: lifetime.lifetimeId)
            case .destruct:
                return nil
            }
        case .none:
            return nil
        }
    }
}
