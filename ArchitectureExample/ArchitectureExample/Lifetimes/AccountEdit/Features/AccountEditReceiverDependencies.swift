//
//  AccountEditReceiverDependencies.swift
//

protocol AccountEditModalLifecycleForAccountEditReceiver: AnyObject {
    func addAlert(id: AccountEditAlertId)
}

protocol AccountEditInteractorForAccountEditReceiver: AnyObject {
    var isEdited: Bool { get }
    func finalize()
}
