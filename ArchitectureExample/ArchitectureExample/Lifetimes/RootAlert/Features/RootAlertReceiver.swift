//
//  RootAlertReceiver.swift
//

final class RootAlertReceiver: GlobalActionReceivable {
    let receivableId: GlobalActionId? = nil

    func receive(_ action: GlobalAction) -> GlobalActionContinuation {
        switch action.kind {
        case .logout:
            return .continue
        case .reopenEdit:
            return .continue
        }
    }
}
