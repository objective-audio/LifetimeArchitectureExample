//
//  RootLifecycle+Action.swift
//

extension RootLifecycle: ActionReceiverProvidable {
    var receivableId: ActionId? { .init(sceneLifetimeId: self.sceneLifetimeId) }

    var receivers: [ActionReceivable] {
        switch self.current {
        case .account(let lifetime):
            return [lifetime.receiver]
        case .launch, .login, .none:
            return []
        }
    }

    var subProviders: [ActionReceiverProvidable] { [] }
}
