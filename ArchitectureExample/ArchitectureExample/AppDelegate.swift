//
//  AppDelegate.swift
//

import UIKit

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate {
    var presenter: AppPresenter?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.presenter = Self.makeAppPresenter()
        self.presenter?.didFinishLaunching()
        return true
    }
}

private extension AppDelegate {
    static func makeAppPresenter() -> AppPresenter? {
        if isNotTest {
            return .init(appLifecycle: LifetimeAccessor.appLifecycle)
        } else {
            return nil
        }
    }
}
