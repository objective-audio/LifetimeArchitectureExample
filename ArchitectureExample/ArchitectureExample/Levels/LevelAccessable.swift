//
//  LevelAccessable.swift
//

@MainActor
protocol LevelAccessable {
    static var app: AppLevel<Self>? { get }
    static func scene(id: SceneLevelId) -> SceneLevel<Self>?
    static func launch(sceneId: SceneLevelId) -> LaunchLevel?
    static func login(sceneId: SceneLevelId) -> LoginLevel?
    static func account(id: AccountLevelId) -> AccountLevel?
    static func accountEdit(id: AccountLevelId) -> AccountEditLevel?
}
