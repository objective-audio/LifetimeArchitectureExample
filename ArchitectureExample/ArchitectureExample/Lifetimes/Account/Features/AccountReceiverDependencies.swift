//
//  AccountReceiverDependencies.swift
//

protocol LogoutInteractorForAccountReceiver: AnyObject {
    func logout()
}

protocol RootModalLifecycleForAccountReceiver: AnyObject {
    func addAccountEdit(accountLifetimeId: AccountLifetimeId)
}
