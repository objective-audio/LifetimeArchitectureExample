//
//  GlobalActionReceiverProvidable.swift
//

@MainActor
protocol GlobalActionReceiverProvidable: AnyObject {
    var receivableId: GlobalActionId? { get }
    var receivers: [GlobalActionReceivable] { get }
    var subProviders: [GlobalActionReceiverProvidable] { get }
}
