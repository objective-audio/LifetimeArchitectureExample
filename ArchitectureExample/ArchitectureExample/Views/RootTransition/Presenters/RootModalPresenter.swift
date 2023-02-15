//
//  RootModalPresenter.swift
//

import Foundation

@MainActor
final class RootModalPresenter: ObservableObject {
    private weak var lifecycle: RootModalLifecycle<RootModalFactory>?

    @Published var isAccountEditSheetPresented: Bool = false {
        didSet {
            if !isAccountEditSheetPresented {
                self.lifecycle?.removeAccountEdit()
            }
        }
    }

    // Alertは必ず何かしらのアクションを受けて閉じるのでfalseがセットされても無視する
    @Published var isLoginFailedAlertPresented: Bool = false

    var accountEditSheet: RootAccountEditSheet? { .init(self.lifecycle?.current) }
    var loginFailedAlert: RootLoginFailedAlert? { .init(self.lifecycle?.current) }

    init(lifecycle: RootModalLifecycle<RootModalFactory>) {
        self.lifecycle = lifecycle

        lifecycle
            .$current
            .map(RootAccountEditSheet.init)
            .map { $0 != nil }
            .assign(to: &$isAccountEditSheetPresented)

        lifecycle
            .$current
            .map(RootLoginFailedAlert.init)
            .map { $0 != nil }
            .assign(to: &$isLoginFailedAlertPresented)
    }
}

extension RootAccountEditSheet {
    init?(_ subLifetime: RootModalSubLifetime<RootModalFactory>?) {
        switch subLifetime {
        case .accountEdit(let lifetime):
            self = .init(lifetimeId: lifetime.lifetimeId)
        case .alert, .none:
            return nil
        }
    }
}

extension RootLoginFailedAlert {
    init?(_ subLifetime: RootModalSubLifetime<RootModalFactory>?) {
        switch subLifetime {
        case .alert(let lifetime):
            switch lifetime.alertId {
            case .loginFailed:
                self = .init(lifetimeId: lifetime.lifetimeId)
            }
        case .accountEdit, .none:
            return nil
        }
    }
}
