//
//  RootModal.swift
//

enum RootModal: Equatable {
    case alert(lifetimeId: RootAlertLifetimeId)
    case accountEdit(lifetimeId: AccountEditLifetimeId)
}
