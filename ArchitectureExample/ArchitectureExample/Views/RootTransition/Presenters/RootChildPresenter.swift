//
//  RootChildPresenter.swift
//

import Combine

@MainActor
final class RootChildPresenter {
    private weak var launchInteractor: LaunchInteractor?

    @Published private(set) var child: RootChild?

    init(launchInteractor: LaunchInteractor,
         rootLifecycle: RootLifecycle<RootFactory>) {
        self.launchInteractor = launchInteractor

        rootLifecycle.$current
            .map(RootChild.init)
            .assign(to: &$child)
    }

    func viewDidAppear() {
        self.launchInteractor?.launch()
    }
}

extension RootChild {
    init?(_ subLifetime: RootSubLifetime<RootFactory>?) {
        switch subLifetime {
        case .none, .launch:
            return nil
        case .login(let lifetime):
            self = .login(lifetimeId: lifetime.sceneLifetimeId)
        case .account(let lifetime):
            self = .account(lifetimeId: lifetime.lifetimeId)
        }
    }
}
