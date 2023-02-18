//
//  ArchitectureExampleScene.swift
//

import SwiftUI

@MainActor
struct ArchitectureExampleScene: Scene {
    let presenter: ScenePresenter?

    init() {
        self.presenter = Self.makeScenePresenter()
    }

    var body: some Scene {
        WindowGroup(for: UUID.self) { uuid in
            if let presenter, presenter.willConnect(uuid: uuid.wrappedValue),
               let childPresenter = Self.makeRootTransitionPresenter(
                sceneLifetimeId: .init(uuid: uuid.wrappedValue)
               ),
               let modalPresenter = Self.makeRootModalPresenter(
                sceneLifetimeId: .init(uuid: uuid.wrappedValue)
               ) {
                RootTransitionView(childPresenter: childPresenter,
                                   modalPresenter: modalPresenter,
                                   factory: RootTransitionViewFactory.self)
                .onDisappear {
                    presenter.didDisconnect(uuid: uuid.wrappedValue)
                }
            } else {
                EmptyView()
            }
        } defaultValue: {
            UUID()
        }
    }
}

@MainActor
private extension ArchitectureExampleScene {
    static func makeScenePresenter() -> ScenePresenter? {
        guard isNotTest else { return nil }

        guard let lifecycle = LifetimeAccessor.app?.sceneLifecycle else {
            assertionFailure()
            return nil
        }

        return .init(lifecycle: lifecycle)
    }

    static func makeRootTransitionPresenter(sceneLifetimeId: SceneLifetimeId) -> RootChildPresenter? {
        guard let sceneLifetime = LifetimeAccessor.scene(id: sceneLifetimeId),
              let launchLifetime = LifetimeAccessor.launch(sceneId: sceneLifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(launchInteractor: launchLifetime.interactor,
                     rootLifecycle: sceneLifetime.rootLifecycle)
    }

    static func makeRootModalPresenter(sceneLifetimeId: SceneLifetimeId) -> RootModalPresenter? {
        guard let sceneLifetime = LifetimeAccessor.scene(id: sceneLifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(lifecycle: sceneLifetime.rootModalLifecycle)
    }

    static func makeRootCommandPresnter(sceneLifetimeId: SceneLifetimeId) -> RootCommandPresenter? {
        guard let appLifetime = LifetimeAccessor.app else {
            assertionFailure()
            return nil
        }

        return .init(sceneLifetimeId: sceneLifetimeId,
                     actionSender: appLifetime.actionSender)
    }
}
