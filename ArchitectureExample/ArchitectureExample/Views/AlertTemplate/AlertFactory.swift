//
//  AlertFactory.swift
//

import UIKit

final class AlertController: UIAlertController {
    fileprivate weak var modalSuspender: ModalSuspendable?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.modalSuspender?.modalWillDismiss()
    }
}

@MainActor
func makeAlertController<Interactor: InteractorForAlertPresenter>(
    alertPresenter: AlertPresenter<Interactor>,
    modalSuspender: ModalSuspendable
) -> UIAlertController {
    let content = alertPresenter.content

    let alert = AlertController(title: content.title,
                                message: content.message,
                                preferredStyle: .alert)

    for action in content.actions {
        alert.addAction(.init(title: action.title,
                              style: action.style,
                              handler: { [weak modalSuspender] _ in
            modalSuspender?.modalDidDismiss()
            alertPresenter.alertWillHandleAction()
            action.handler()
        }))
    }

    return alert
}
