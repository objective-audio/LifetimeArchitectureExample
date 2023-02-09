//
//  AccountNavigationPresenter.swift
//

import Combine

@MainActor
final class AccountNavigationPresenter: ObservableObject {
    let accountLifetimeId: AccountLifetimeId
    private weak var navigationLifecycle: AccountNavigationLifecycle<AccountNavigationFactory>?

    @Published var elements: [AccountNavigationElement] = [] {
        didSet {
            if self.elements != oldValue {
                self.revertStack()
            }
        }
    }

    private var cancellables: Set<AnyCancellable> = .init()

    init(accountLifetimeId: AccountLifetimeId,
         navigationLifecycle: AccountNavigationLifecycle<AccountNavigationFactory>) {
        self.accountLifetimeId = accountLifetimeId
        self.navigationLifecycle = navigationLifecycle

        navigationLifecycle
            .$stack
            .map { $0.map(AccountNavigationElement.init) }
            .assign(to: &self.$elements)
    }
}

private extension AccountNavigationPresenter {
    func revertStack() {
        guard let lifecycle = self.navigationLifecycle else {
            assertionFailure()
            return
        }

        var revertedStack: [AccountNavigationSubLifetime<AccountNavigationFactory>] = []

        let lifecycleElements = lifecycle.stack.map(AccountNavigationElement.init)

        for (index, element) in self.elements.enumerated() {
            guard index < lifecycleElements.count else {
                break
            }

            guard element == lifecycleElements[index] else {
                break
            }

            revertedStack.append(lifecycle.stack[index])
        }

        lifecycle.revert(stack: revertedStack)
    }
}

extension AccountNavigationElement {
    init(_ subLifetime: AccountNavigationSubLifetime<AccountNavigationFactory>) {
        switch subLifetime {
        case .info(let lifetime):
            self = .info(uiSystem: lifetime.interactor.uiSystem,
                         lifetimeId: lifetime.lifetimeId)
        case .detail(let lifetime):
            self = .detail(lifetimeId: lifetime.lifetimeId)
        }
    }
}
