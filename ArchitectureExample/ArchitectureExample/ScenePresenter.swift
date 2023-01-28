//
//  ScenePresenter.swift
//

@MainActor
final class ScenePresenter {
    private weak var lifecycle: SceneLifecycle<SceneFactory>?

    init(lifecycle: SceneLifecycle<SceneFactory>) {
        self.lifecycle = lifecycle
    }

    func willConnect(id: SceneLifetimeId) {
        self.lifecycle?.append(id: id)
    }

    func didDisconnect(id: SceneLifetimeId) {
        self.lifecycle?.remove(id: id)
    }
}
