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

    var destructAlertLifetimeId: AccountEditAlertLifetimeId? { .makeDestruct(self.lifecycle?.current) }
    var logoutAlertLifetimeId: AccountEditAlertLifetimeId? { .makeLogout(self.lifecycle?.current) }

    init(lifecycle: AccountEditModalLifecycle<AccountEditModalFactory>) {
        self.lifecycle = lifecycle

        lifecycle
            .$current
            .map(AccountEditAlertLifetimeId.makeDestruct)
            .map { $0 != nil }
            .assign(to: &$isDestructAlertPresented)

        lifecycle
            .$current
            .map(AccountEditAlertLifetimeId.makeLogout)
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

private extension AccountEditAlertLifetimeId {
    static func makeDestruct(
        _ subLifetime: AccountEditModalSubLifetime<AccountEditModalFactory>?
    ) -> AccountEditAlertLifetimeId? {
        switch subLifetime {
        case .alert(let lifetime):
            switch lifetime.alertId {
            case .destruct:
                return lifetime.lifetimeId
            case .logout:
                return nil
            }
        case .none:
            return nil
        }
    }

    static func makeLogout(
        _ subLifetime: AccountEditModalSubLifetime<AccountEditModalFactory>?
    ) -> AccountEditAlertLifetimeId? {
        switch subLifetime {
        case .alert(let lifetime):
            switch lifetime.alertId {
            case .logout:
                return lifetime.lifetimeId
            case .destruct:
                return nil
            }
        case .none:
            return nil
        }
    }
}
