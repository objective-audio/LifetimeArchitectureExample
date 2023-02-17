//
//  RootModalPresenter.swift
//

import Foundation

@MainActor
final class RootModalPresenter: ObservableObject {
    private weak var lifecycle: RootModalLifecycle<RootModalFactory>?

    // Sheet内のonDisappearで処理されるので、falseがセットされても無視する
    @Published var isAccountEditSheetPresented: Bool = false

    // Alertは必ず何かしらのアクションを受けて閉じるので、falseがセットされても無視する
    @Published var isLoginFailedAlertPresented: Bool = false

    var accountEditLifetimeId: AccountEditLifetimeId? { .init(self.lifecycle?.current) }
    var loginFailedAlertLifetimeId: RootAlertLifetimeId? { .init(self.lifecycle?.current) }

    init(lifecycle: RootModalLifecycle<RootModalFactory>) {
        self.lifecycle = lifecycle

        lifecycle
            .$current
            .map(AccountEditLifetimeId.init)
            .map { $0 != nil }
            .assign(to: &$isAccountEditSheetPresented)

        lifecycle
            .$current
            .map(RootAlertLifetimeId.init)
            .map { $0 != nil }
            .assign(to: &$isLoginFailedAlertPresented)
    }
}

private extension AccountEditLifetimeId {
    init?(_ subLifetime: RootModalSubLifetime<RootModalFactory>?) {
        switch subLifetime {
        case .accountEdit(let lifetime):
            self = lifetime.lifetimeId
        case .alert, .none:
            return nil
        }
    }
}

private extension RootAlertLifetimeId {
    init?(_ subLifetime: RootModalSubLifetime<RootModalFactory>?) {
        switch subLifetime {
        case .alert(let lifetime):
            self = lifetime.lifetimeId
        case .accountEdit, .none:
            return nil
        }
    }
}
