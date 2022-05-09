//
//  AppLifecycle.swift
//

@MainActor
final class AppLifecycle<Accessor: LifetimeAccessable> {
    @CurrentValue private(set) var lifetime: AppLifetime<Accessor>?
}

extension AppLifecycle {
    func add() {
        guard self.lifetime == nil else {
            assertionFailureIfNotTest()
            return
        }

        self.lifetime = Self.makeAppLifetime()
    }
}
