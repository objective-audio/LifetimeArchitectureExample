//
//  AppPresenter.swift
//

@MainActor
final class AppPresenter {
    private weak var appLifecycle: AppLifecycle<LifetimeAccessor>?

    init(appLifecycle: AppLifecycle<LifetimeAccessor>) {
        self.appLifecycle = appLifecycle
    }

    func didFinishLaunching() {
        self.appLifecycle?.add()
    }
}
