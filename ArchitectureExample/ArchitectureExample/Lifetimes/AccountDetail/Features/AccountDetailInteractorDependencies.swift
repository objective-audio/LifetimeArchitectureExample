//
//  AccountDetailInteractorDependencies.swift
//

protocol AccountNavigationLifecycleForAccountDetailInteractor: AnyObject {
    func canPopDetail(lifetimeId: AccountDetailLifetimeId) -> Bool
    func popDetail(lifetimeId: AccountDetailLifetimeId)
}
