//
//  RootModalLifecycle+Action.swift
//

extension RootModalLifecycle: GlobalActionReceiverProvidable {
    var receivableId: GlobalActionId? { .init(sceneLifetimeId: self.sceneLifetimeId) }

    var receivers: [GlobalActionReceivable] {
        switch self.current {
        case .accountEdit(let lifetime):
            return [lifetime.receiver]
        case .alert(let lifetime):
            return [lifetime.receiver]
        case .none:
            return []
        }
    }

    var subProviders: [GlobalActionReceiverProvidable] {
        switch self.current {
        case .accountEdit(let lifetime):
            return [lifetime.modalLifecycle]
        case .alert, .none:
            return []
        }
    }
}
