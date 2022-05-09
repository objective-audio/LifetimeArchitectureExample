//
//  LifetimeAccessable.swift
//

/**
 Lifetimeを取得するためのインターフェース
 テストにおいて空で返せるように定義している
 */

@MainActor
protocol LifetimeAccessable {
    static var app: AppLifetime<Self>? { get }
    static func scene(id: SceneLifetimeId) -> SceneLifetime<Self>?
    static func launch(sceneId: SceneLifetimeId) -> LaunchLifetime?
    static func login(sceneId: SceneLifetimeId) -> LoginLifetime?
    static func account(id: AccountLifetimeId) -> AccountLifetime<Self>?
    static func accountEdit(id: AccountEditLifetimeId) -> AccountEditLifetime<Self>?
}
