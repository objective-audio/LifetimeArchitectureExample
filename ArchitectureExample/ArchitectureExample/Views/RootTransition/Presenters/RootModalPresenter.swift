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

    var modal: RootModal? { .init(self.lifecycle?.current) }

    init(lifecycle: RootModalLifecycle<RootModalFactory>) {
        self.lifecycle = lifecycle

        let modal = lifecycle
            .$current
            .map(RootModal.init)

        modal
            .map {
                switch $0 {
                case .accountEdit:
                    return true
                case .alert, .none:
                    return false
                }
            }
            .assign(to: &$isAccountEditSheetPresented)

        modal
            .map {
                switch $0 {
                case .alert:
                    return true
                case .accountEdit, .none:
                    return false
                }
            }
            .assign(to: &$isLoginFailedAlertPresented)
    }
}

private extension RootModal {
    init?(_ subLifetime: RootModalSubLifetime<RootModalFactory>?) {
        switch subLifetime {
        case .accountEdit(let lifetime):
            self = .accountEdit(lifetimeId: lifetime.lifetimeId)
        case .alert(let lifetime):
            self = .alert(lifetimeId: lifetime.lifetimeId)
        case .none:
            return nil
        }
    }
}
