//
//  ActionReceivable.swift
//

@MainActor
protocol ActionReceivable {
    var receivableId: ActionId? { get }
    func receive(_ action: Action) -> ActionContinuation
}
