//
//  AlertFactory.swift
//

import UIKit

@MainActor
func makeAlertController<Router: RouterForAlertPresenter>(presenter: AlertPresenter<Router>) -> UIAlertController {
    let content = presenter.content
    
    let alert = UIAlertController(title: content.title,
                                  message: content.message,
                                  preferredStyle: .alert)
    
    for action in content.actions {
        alert.addAction(.init(title: action.title,
                              style: action.style,
                              handler: { _ in
            presenter.alertWillHandleAction()
            action.handler()
        }))
    }
    
    return alert
}
