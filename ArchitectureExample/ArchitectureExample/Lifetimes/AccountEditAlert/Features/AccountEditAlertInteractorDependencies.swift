//
//  AccountEditAlertInteractorDependencies.swift
//

protocol AccountEditModalLifecycleForAccountEditAlertInteractor: AnyObject {
    func removeAlert(lifetimeId: AccountEditAlertLifetimeId)
}

protocol AccountEditInteractorForAccountEditAlertInteractor: AnyObject {
    func logout()
    func finalize()
}
