//
//  ActionSender.swift
//

/**
 Lifetimeのヒエラルキー全体にActionを送信する
 通常は個々のFeatureを呼び出すべきで、乱用してはいけない
 */

@MainActor
final class ActionSender {
    private unowned let rootProvider: any GlobalActionReceiverProvidable

    init(rootProvider: any GlobalActionReceiverProvidable) {
        self.rootProvider = rootProvider
    }

    func send(_ action: GlobalAction) {
        let receivers = self.rootProvider.receivers(for: action.id)

        for receiver in receivers {
            switch receiver.receive(action) {
            case .break:
                return
            case .continue:
                break
            }
        }
    }
}

extension ActionSender {
    func sendLogout(accountLifetimeId: AccountLifetimeId) {
        self.send(.init(kind: .logout,
                        id: .init(accountLifetimeId: accountLifetimeId)))
    }
}

private extension GlobalActionReceiverProvidable {
    func providers(for actionId: GlobalActionId?) -> [GlobalActionReceiverProvidable] {
        if self.receivableId.isMatch(actionId) {
            return self.subProviders
                .flatMap { $0.providers(for: actionId) } + [self]
        } else {
            return []
        }
    }

    func receivers(for actionId: GlobalActionId?) -> [GlobalActionReceivable] {
        let receivers = self.providers(for: actionId).flatMap { $0.receivers }

        if let actionId {
            return receivers
                .filter { $0.receivableId.isMatch(actionId) }
        } else {
            return receivers
        }
    }
}
