//
//  AppLifecycle.swift
//

@MainActor
final class AppLifecycle<Factory: FactoryForAppLifecycle> {
    @CurrentValue private(set) var lifetime: Factory.AppLifetime?

    init(factory: Factory.Type) {}
}

extension AppLifecycle {
    func add() {
        guard self.lifetime == nil else {
            assertionFailureIfNotTest()
            return
        }

        self.lifetime = Factory.makeAppLifetime()
    }
}
