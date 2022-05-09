//
//  UIViewController+Modal.swift
//

import UIKit

@MainActor
protocol ModalPresentableViewController: UIViewController {
    var modalSuspender: ModalSuspendable { get }
}

extension ModalPresentableViewController {
    func presentModal(_ viewController: UIViewController) {
        if self.presentedViewController != nil {
            self.modalSuspender.modalWillDismiss()
            self.dismiss(animated: true) { [weak self] in
                self?.present(viewController, animated: true) {
                    self?.modalSuspender.modalDidPresent()
                }
            }
        } else {
            self.modalSuspender.modalWillPresent()
            self.present(viewController, animated: true) { [weak self] in
                self?.modalSuspender.modalDidPresent()
            }
        }
    }

    func dismissModal() {
        guard self.presentedViewController != nil else {
            return
        }

        self.modalSuspender.modalWillDismiss()
        self.dismiss(animated: true) { [weak self] in
            self?.modalSuspender.modalDidDismiss()
        }
    }
}
