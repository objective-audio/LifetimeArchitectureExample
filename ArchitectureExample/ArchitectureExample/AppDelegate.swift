//
//  AppDelegate.swift
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let presenter: AppPresenter?

    override init() {
        if isNotTest {
            self.presenter = Self.makeAppPresenter()
        } else {
            self.presenter = nil
        }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.presenter?.didFinishLaunching()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

private extension AppDelegate {
    static func makeAppPresenter() -> AppPresenter {
        return .init(appLifecycle: LifetimeAccessor.appLifecycle)
    }
}
