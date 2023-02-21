//
//  GlobalActionReceivable.swift
//

protocol GlobalActionReceivable {
    var receivableId: GlobalActionId? { get }
    func receive(_ action: GlobalAction) -> GlobalActionContinuation
}
