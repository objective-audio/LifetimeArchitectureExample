//
//  RootTransitionChildPresenter.swift
//

import Combine
import UIKit

@MainActor
final class RootTransitionChildPresenter {
    private weak var launchInteractor: LaunchInteractor?

    @CurrentValue private(set) var child: RootChild?

    private var cancellables: Set<AnyCancellable> = .init()

    init(launchInteractor: LaunchInteractor,
         rootLifecycle: RootLifecycle<RootFactory>) {
        self.launchInteractor = launchInteractor

        rootLifecycle.$current
            .map(RootChild.init)
            .assign(to: \.value,
                    on: self.$child)
            .store(in: &self.cancellables)
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
