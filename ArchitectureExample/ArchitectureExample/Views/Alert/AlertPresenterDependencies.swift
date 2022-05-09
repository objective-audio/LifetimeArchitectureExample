//
//  AlertPresenterDependencies.swift
//

protocol RouterForAlertPresenter: AnyObject {
    associatedtype AlertID: Equatable
    
    func hideAlert(id: AlertID)
}
