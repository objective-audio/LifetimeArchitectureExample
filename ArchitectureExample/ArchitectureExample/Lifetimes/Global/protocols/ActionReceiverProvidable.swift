//
//  ActionReceiverProvidable.swift
//

@MainActor
protocol ActionReceiverProvidable: AnyObject {
    var receivableId: ActionId? { get }
    var receivers: [ActionReceivable] { get }
    var subProviders: [ActionReceiverProvidable] { get }
}
