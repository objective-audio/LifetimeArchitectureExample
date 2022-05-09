//
//  RootModalLifecycle+Action.swift
//

extension RootModalLifecycle: ActionReceiverProvidable {
    var receivableId: ActionId? { .init(sceneLifetimeId: self.sceneLifetimeId) }

    var receivers: [ActionReceivable] {
        switch self.current {
        case .accountEdit(let lifetime):
            return [lifetime.receiver]
        case .alert(let lifetime):
            return [lifetime.receiver]
        case .none:
            return []
        }
    }

    var subProviders: [ActionReceiverProvidable] {
        switch self.current {
        case .accountEdit(let lifetime):
            return [lifetime.modalLifecycle]
        case .alert, .none:
            return []
        }
    }
}
