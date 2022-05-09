//
//  EmptyLevelAccessor.swift
//

@testable import ArchitectureExample

final class EmptyLevelAccessor: LevelAccessable {
    static var app: AppLevel<EmptyLevelAccessor>? { nil }
    static func scene(id: SceneLevelId) -> SceneLevel<EmptyLevelAccessor>? { nil }
    static func launch(sceneId: SceneLevelId) -> LaunchLevel? { nil }
    static func login(sceneId: SceneLevelId) -> LoginLevel? { nil }
    static func account(id: AccountLevelId) -> AccountLevel? { nil }
    static func accountEdit(id: AccountLevelId) -> AccountEditLevel? { nil }
}
