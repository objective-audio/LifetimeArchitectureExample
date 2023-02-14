//
//  AccountEditModalPresenter.swift
//

import Foundation

@MainActor
final class AccountEditModalPresenter: ObservableObject {
    private weak var lifecycle: AccountEditModalLifecycle<AccountEditModalFactory>?

    @Published var isDestructAlertPresented: Bool = false {
        didSet {
            if !isDestructAlertPresented {
                self.lifecycle?.removeAlert(id: .destruct)
            }
        }
    }

    @Published var isLogoutAlertPresented: Bool = false {
        didSet {
            if !isLogoutAlertPresented {
                self.lifecycle?.removeAlert(id: .logout)
            }
        }
    }

    var destructAlert: AccountEditDestructAlert? { .init(self.lifecycle?.current) }
    var logoutAlert: AccountEditLogoutAlert? { .init(self.lifecycle?.current) }

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
