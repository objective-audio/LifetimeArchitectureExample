//
//  AccountMenuInteractorDependencies.swift
//

protocol AccountNavigationLifecycleForAccountMenuInteractor: AnyObject {
    var canPushInfo: Bool { get }
    func pushInfo(uiSystem: UISystem)
}

protocol ActionSenderForAccountMenuInteractor: AnyObject {
    func sendLogout(accountLifetimeId: AccountLifetimeId)
}
