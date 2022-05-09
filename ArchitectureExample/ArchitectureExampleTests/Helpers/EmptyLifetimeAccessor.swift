//
//  EmptyLifetimeAccessor.swift
//

@testable import ArchitectureExample

final class EmptyLifetimeAccessor: LifetimeAccessable {
    static var app: AppLifetime<EmptyLifetimeAccessor>? { nil }
    static func scene(id: SceneLifetimeId) -> SceneLifetime<EmptyLifetimeAccessor>? { nil }
    static func launch(sceneId: SceneLifetimeId) -> LaunchLifetime? { nil }
    static func login(sceneId: SceneLifetimeId) -> LoginLifetime? { nil }
    static func account(id: AccountLifetimeId) -> AccountLifetime<EmptyLifetimeAccessor>? { nil }
    static func accountEdit(id: AccountEditLifetimeId) -> AccountEditLifetime<EmptyLifetimeAccessor>? { nil }
}
