//
//  ModalSuspendable.swift
//

@MainActor
protocol ModalSuspendable: AnyObject {
    func modalWillPresent()
    func modalDidPresent()
    func modalWillDismiss()
    func modalDidDismiss()
}
