//
//  AccountNavigationViewController.swift
//

import UIKit
import Combine

final class AccountNavigationViewController: UINavigationController {
    private let presenter: AccountNavigationPresenter
    private var cancellables: Set<AnyCancellable> = .init()
    
    static func instantiate(presenter: AccountNavigationPresenter) -> AccountNavigationViewController {
        let storyboard = UIStoryboard(name: "AccountNavigation",
                                      bundle: nil)
        
        guard let navigation = storyboard
            .instantiateInitialViewController(creator: { coder in
                AccountNavigationViewController(coder: coder,
                                                presenter: presenter)
            }) else { fatalError() }
        
        return navigation
    }
    
    required init?(coder: NSCoder,
                   presenter: AccountNavigationPresenter) {
        self.presenter = presenter
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.prefersLargeTitles = true
        
        let accountLevelId = self.presenter.accountLevelId
        
        self.presenter.$views
            .removeDuplicates()
            .sink { [weak self] views in
                self?.updateViewControllers(elements: views,
                                            fetching: { AccountNavigationPresenter.View($0) },
                                            making: { $0.makeViewController(accountLevelId: accountLevelId) })
            }.store(in: &self.cancellables)
    }
}

private extension AccountNavigationPresenter.View {
    init(_ viewController: UIViewController) {
        switch viewController {
        case is AccountMenuHostingController:
            self = .menu
        case is AccountInfoHostingController:
            self = .info(.swiftUI)
        case is AccountInfoViewController:
            self = .info(.uiKit)
        default:
            fatalError()
        }
    }
    
    func makeViewController(accountLevelId: AccountLevelId) -> UIViewController? {
        switch self {
        case .menu:
            return AccountMenuHostingController(accountLevelId: accountLevelId)
        case .info(.swiftUI):
            return AccountInfoHostingController(accountLevelId: accountLevelId)
        case .info(.uiKit):
            return AccountInfoViewController.instantiate(accountLevelId: accountLevelId)
        }
    }
}
