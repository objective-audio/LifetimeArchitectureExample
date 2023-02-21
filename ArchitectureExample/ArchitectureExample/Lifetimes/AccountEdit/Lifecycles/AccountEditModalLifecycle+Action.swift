//
//  AccountEditModalLifecycle+Action.swift
//

extension AccountEditModalLifecycle: GlobalActionReceiverProvidable {
    var receivableId: GlobalActionId? {
        .init(accountLifetimeId: self.lifetimeId.account)
    }

    var receivers: [GlobalActionReceivable] {
        switch self.current {
        case .alert(let lifetime):
            return [lifetime.receiver]
        case .none:
            return []
        }
    }

    var subProviders: [GlobalActionReceiverProvidable] { [] }
}
