//
//  SceneLifecycle+Action.swift
//

extension SceneLifecycle: ActionReceiverProvidable {
    var receivableId: ActionId? { nil }
    var receivers: [ActionReceivable] { [] }

    var subProviders: [ActionReceiverProvidable] {
        self.lifetimes.flatMap {
            [$0.rootModalLifecycle,
             $0.rootLifecycle] as [ActionReceiverProvidable]
        }
    }
}
