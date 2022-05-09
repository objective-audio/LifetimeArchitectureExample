//
//  RootViewController.swift
//

import UIKit
import Combine

final class RootViewController: UIViewController {
    private var presenter: RootPresenter?
    private var cancellables: Set<AnyCancellable> = .init()
    
    func setup(presenter: RootPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let presenter = self.presenter else {
            assertionFailureIfNotTest()
            return
        }
        
        presenter.$view
            .removeDuplicates()
            .sink { [weak self] view in
                guard let self = self,
                      let sceneLevelId = self.presenter?.sceneLevelId else {
                    return
                }
                
                switch view {
                case .login:
                    self.replaceChild(LoginHostingController(sceneId: sceneLevelId))
                case .account(let accountId):
                    let accountLevelId = AccountLevelId(sceneLevelId: sceneLevelId,
                                                        accountId: accountId)
                    self.replaceChild(
                        AccountNavigationViewController
                            .instantiate(accountLevelId: accountLevelId))
                case .none:
                    self.replaceChild(nil)
                }
            }.store(in: &self.cancellables)
        
        presenter.$modal
            .removeDuplicates()
            .sink { [weak self] modal in
                switch modal {
                case .alert(let content):
                    self?.presentAlertIfNeeded(content: content)
                case .accountEdit(let accountLevelId):
                    self?.presentAccountEdit(accountLevelId: accountLevelId)
                case .none:
                    self?.dismissModal()
                }
            }.store(in: &self.cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.viewDidAppear()
    }
}

private extension RootViewController {
    func presentAlertIfNeeded(content: RootAlertContent) {
        guard self.presentedViewController == nil,
              let sceneLevelId = self.presenter?.sceneLevelId,
              let alert = makeRootAlertController(sceneLevelId: sceneLevelId,
                                                  content: content) else {
            assertionFailure()
            return
        }

        self.present(alert, animated: true)
    }
    
    func presentAccountEdit(accountLevelId: AccountLevelId) {
        guard self.presentedViewController == nil,
              let sceneLevelId = self.presenter?.sceneLevelId,
              sceneLevelId == accountLevelId.sceneLevelId,
              let presenting = AccountEditRootViewController(accountLevelId: accountLevelId) else {
            assertionFailure()
            return
        }
        
        self.present(presenting, animated: true)
    }
    
    func dismissModal() {
        guard self.presentedViewController != nil else {
            return
        }
        
        self.dismiss(animated: true)
    }
}
