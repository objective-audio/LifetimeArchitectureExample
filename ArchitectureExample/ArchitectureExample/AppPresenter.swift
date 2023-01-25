//
//  AppPresenter.swift
//

@MainActor
final class AppPresenter {
    private weak var appLifecycle: AppLifecycle<AppFactory>?

    init(appLifecycle: AppLifecycle<AppFactory>) {
        self.appLifecycle = appLifecycle
    }

    func didFinishLaunching() {
        self.appLifecycle?.add()
    }
}
