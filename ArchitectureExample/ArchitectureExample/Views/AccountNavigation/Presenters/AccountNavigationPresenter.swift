//
//  AccountNavigationPresenter.swift
//

import Combine

@MainActor
final class AccountNavigationPresenter {
    private weak var navigationLifecycle: AccountNavigationLifecycle<AccountNavigationFactory>?

    @CurrentValue private(set) var elements: [AccountNavigationElement] = []

    private var cancellables: Set<AnyCancellable> = .init()

    init(navigationLifecycle: AccountNavigationLifecycle<AccountNavigationFactory>) {
        self.navigationLifecycle = navigationLifecycle

        navigationLifecycle.$stack
            .map { $0.map(AccountNavigationElement.init) }
            .assign(to: \.value,
                    on: self.$elements)
            .store(in: &self.cancellables)
    }
}

extension AccountNavigationElement {
    init(_ subLifetime: AccountNavigationSubLifetime<AccountNavigationFactory>) {
        switch subLifetime {
        case .menu(let lifetime):
            self = .menu(lifetimeId: lifetime.lifetimeId)
        case .info(let lifetime):
            self = .info(uiSystem: lifetime.interactor.uiSystem,
                         lifetimeId: lifetime.lifetimeId)
        case .detail(let lifetime):
            self = .detail(lifetimeId: lifetime.lifetimeId)
        }
    }
}
