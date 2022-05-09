//
//  AccountNavigationController.swift
//

import UIKit
import Combine

final class AccountNavigationController: UINavigationController {
    private let presenter: AccountNavigationPresenter
    private var cancellables: Set<AnyCancellable> = .init()

    static func instantiate(presenter: AccountNavigationPresenter) -> AccountNavigationController {
        let storyboard = UIStoryboard(name: "AccountNavigation",
                                      bundle: nil)

        guard let navigation = storyboard
            .instantiateInitialViewController(creator: { coder in
                AccountNavigationController(coder: coder,
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

        var oldElements: [AccountNavigationElement] = []

        self.presenter.$elements
            .removeDuplicates()
            .sink { [weak self] elements in
                guard let self = self else { return }
                self.updateViewControllers(newElements: elements,
                                           oldElements: oldElements,
                                           making: { $0.makeViewController() })
                oldElements = elements
            }.store(in: &self.cancellables)
    }
}

private extension AccountNavigationElement {
    func makeViewController() -> UIViewController? {
        typealias Factory = AccountNavigationController

        switch self {
        case .menu(let lifetimeId):
            return Factory.makeAccountMenuHostingController(lifetimeId: lifetimeId)
        case .info(.swiftUI, let lifetimeId):
            return Factory.makeAccountInfoHostingController(lifetimeId: lifetimeId)
        case .info(.uiKit, let lifetimeId):
            return Factory.makeAccountInfoViewController(lifetimeId: lifetimeId)
        }
    }
}
