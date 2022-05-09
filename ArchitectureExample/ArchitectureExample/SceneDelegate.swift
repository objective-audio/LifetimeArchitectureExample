//
//  SceneDelegate.swift
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let instanceId: InstanceId = .init()
    private var presenter: ScenePresenter?
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if isNotTest, self.presenter == nil {
            self.presenter = .init()
        }
        
        guard let windowScene = scene as? UIWindowScene,
              let presenter = self.presenter else { return }
        
        let sceneLevelId = SceneLevelId(instanceId: self.instanceId)
        
        presenter.willConnect(id: sceneLevelId)
        
        guard let rootViewController = windowScene.windows.compactMap({ $0.rootViewController as? RootViewController }).first else {
            assertionFailure()
            return
        }
        
        guard let rootPresenter = RootPresenter(sceneLevelId: sceneLevelId) else { return }
        
        rootViewController.setup(presenter: rootPresenter)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        self.presenter?.didConnect(id: .init(instanceId: self.instanceId))
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

private extension ScenePresenter {
    convenience init?() {
        guard let router = LevelAccessor.app?.sceneRouter else {
            assertionFailure()
            return nil
        }
        
        self.init(router: router)
    }
}

// MARK: - RootPresenter

private extension RootPresenter {
    convenience init?(sceneLevelId: SceneLevelId) {
        guard let sceneLevel = LevelAccessor.scene(id: sceneLevelId),
              let launchLevel = LevelAccessor.launch(sceneId: sceneLevelId) else {
            assertionFailure()
            return nil
        }
        
        self.init(sceneLevelId: sceneLevelId,
                  launchInteractor: launchLevel.interactor,
                  router: sceneLevel.rootRouter,
                  modalRouter: sceneLevel.rootModalRouter)
    }
}
