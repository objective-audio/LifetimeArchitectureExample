//
//  RootLifecycle+Action.swift
//

extension RootLifecycle: GlobalActionReceiverProvidable {
    var receivableId: GlobalActionId? { .init(sceneLifetimeId: self.sceneLifetimeId) }

    var receivers: [GlobalActionReceivable] {
        switch self.current {
        case .account(let lifetime):
            return [lifetime.receiver]
        case .launch, .login, .none:
            return []
        }
    }

    var subProviders: [GlobalActionReceiverProvidable] { [] }
}
