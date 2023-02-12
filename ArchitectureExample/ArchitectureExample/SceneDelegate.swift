//
//  SceneDelegate.swift
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let instanceId: InstanceId = .init()
    private var presenter: ScenePresenter?

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if isNotTest, self.presenter == nil {
            self.presenter = Self.makeScenePresenter()
        }

        guard let windowScene = scene as? UIWindowScene,
              let presenter = self.presenter else { return }

        let sceneLifetimeId = SceneLifetimeId(instanceId: self.instanceId)

        presenter.willConnect(id: sceneLifetimeId)

        guard let transitionViewController = windowScene.windows.compactMap({
            $0.rootViewController as? RootTransitionViewController
        }).first else {
            assertionFailure()
            return
        }

        guard let childPresenter = Self.makeRootTransitionPresenter(sceneLifetimeId: sceneLifetimeId),
              let modalPresenter = Self.makeRootModalPresenter(sceneLifetimeId: sceneLifetimeId),
              let commandPresenter = Self.makeRootCommandPresnter(sceneLifetimeId: sceneLifetimeId) else {
            return
        }

        transitionViewController.setup(childPresenter: childPresenter,
                                       modalPresenter: modalPresenter,
                                       commandPresenter: commandPresenter)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        self.presenter?.didDisconnect(id: .init(instanceId: self.instanceId))
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

// MARK: - ScenePresenter

private extension SceneDelegate {
    static func makeScenePresenter() -> ScenePresenter? {
        guard let lifecycle = LifetimeAccessor.app?.sceneLifecycle else {
            assertionFailure()
            return nil
        }

        return .init(lifecycle: lifecycle)
    }
}

// MARK: - RootPresenter

private extension SceneDelegate {
    static func makeRootTransitionPresenter(sceneLifetimeId: SceneLifetimeId) -> RootTransitionChildPresenter? {
        guard let sceneLifetime = LifetimeAccessor.scene(id: sceneLifetimeId),
              let launchLifetime = LifetimeAccessor.launch(sceneId: sceneLifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(launchInteractor: launchLifetime.interactor,
                     rootLifecycle: sceneLifetime.rootLifecycle)
    }

    static func makeRootModalPresenter(sceneLifetimeId: SceneLifetimeId) -> RootTransitionModalPresenter? {
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
