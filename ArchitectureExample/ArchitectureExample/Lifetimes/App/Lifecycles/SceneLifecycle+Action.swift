//
//  SceneLifecycle+Action.swift
//

extension SceneLifecycle: GlobalActionReceiverProvidable {
    var receivableId: GlobalActionId? { nil }
    var receivers: [GlobalActionReceivable] { [] }

    var subProviders: [GlobalActionReceiverProvidable] {
        self.lifetimes.flatMap {
            [$0.rootModalLifecycle,
             $0.rootLifecycle] as [GlobalActionReceiverProvidable]
        }
    }
}
