//
//  RootAlertReceiver.swift
//

final class RootAlertReceiver: ActionReceivable {
    let receivableId: ActionId? = nil

    func receive(_ action: Action) -> ActionContinuation {
        switch action.kind {
        case .logout:
            return .continue
        case .reopenEdit:
            return .continue
        }
    }
}
