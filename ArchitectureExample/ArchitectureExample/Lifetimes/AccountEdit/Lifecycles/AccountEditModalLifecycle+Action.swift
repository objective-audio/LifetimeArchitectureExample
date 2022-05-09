//
//  AccountEditModalLifecycle+Action.swift
//

extension AccountEditModalLifecycle: ActionReceiverProvidable {
    var receivableId: ActionId? {
        .init(accountLifetimeId: self.lifetimeId.account)
    }

    var receivers: [ActionReceivable] {
        switch self.current {
        case .alert(let lifetime):
            return [lifetime.receiver]
        case .none:
            return []
        }
    }

    var subProviders: [ActionReceiverProvidable] { [] }
}
