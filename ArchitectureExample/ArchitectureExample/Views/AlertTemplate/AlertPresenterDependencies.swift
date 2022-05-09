//
//  AlertPresenterDependencies.swift
//

protocol LifecycleForAlertPresenter: AnyObject {
    associatedtype AlertID: Equatable

    func removeAlert(id: AlertID)
}

protocol InteractorForAlertPresenter: AnyObject {
    associatedtype AlertID: Equatable

    var content: AlertContent<AlertID> { get }
    func finalize()
}
