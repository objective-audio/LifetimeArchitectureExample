//
//  AccountEditRootViewController.swift
//

import UIKit
import Combine

final class AccountEditRootViewController: UIViewController {
    private let presenter: AccountEditRootPresenter
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(presenter: AccountEditRootPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presentationController?.delegate = self
        
        presenter.$isModalInPresentation
            .sink { [weak self] isModal in
                self?.isModalInPresentation = isModal
            }
            .store(in: &self.cancellables)
        
        presenter.$modal
            .removeDuplicates()
            .sink { [weak self] modal in
                switch modal {
                case .alert(let content):
                    self?.presentAlertIfNeeded(content: content)
                case .none:
                    self?.dismissModal()
                }
            }
            .store(in: &self.cancellables)
        
        if let child = AccountEditHostingController(accountLevelId: presenter.accountLevelId) {
            self.presentChild(child, duration: 0.0)
        } else {
            assertionFailure()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountEditRootViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.presenter.viewDidDismiss()
    }
}

private extension AccountEditRootViewController {
    func presentAlertIfNeeded(content: AccountEditAlertContent) {
        let accountLevelId = self.presenter.accountLevelId
        
        guard self.presentedViewController == nil,
              let alert = makeAccountEditAlertController(accountLevelId: accountLevelId,
                                                         content: content) else {
            assertionFailure()
            return
        }

        self.present(alert, animated: true)
    }
    
    func dismissModal() {
        guard self.presentedViewController != nil else {
            return
        }
        
        self.dismiss(animated: true)
    }
}
