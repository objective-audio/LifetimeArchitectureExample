//
//  ScenePresenter.swift
//

import Foundation

@MainActor
final class ScenePresenter {
    private weak var lifecycle: SceneLifecycle<SceneFactory>?

    init(lifecycle: SceneLifecycle<SceneFactory>) {
        self.lifecycle = lifecycle
    }

    func willConnect(uuid: UUID) -> Bool {
        guard isNotTest,
              let lifecycle = self.lifecycle else { return false }

        let lifetimeId = SceneLifetimeId(uuid: uuid)

        if !lifecycle.contains(lifetimeId) {
            lifecycle.append(id: lifetimeId)
        }

        return true
    }

    func didDisconnect(uuid: UUID) {
        self.lifecycle?.remove(id: .init(uuid: uuid))
    }
}
