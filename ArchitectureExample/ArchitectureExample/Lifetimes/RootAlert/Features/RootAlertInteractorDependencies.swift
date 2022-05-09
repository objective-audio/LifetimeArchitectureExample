//
//  RootAlertInteractorDependencies.swift
//

protocol RootModalLifecycleForRootAlertInteractor: AnyObject {
    func removeAlert(lifetimeId: RootAlertLifetimeId)
}
