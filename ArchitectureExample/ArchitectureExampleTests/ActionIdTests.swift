//
//  ActionIdTests.swift
//

import XCTest
@testable import ArchitectureExample

class ActionIdTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testIsMatch() {
        let sceneIdA = SceneLifetimeId(uuid: .init())
        let sceneIdB = SceneLifetimeId(uuid: .init())

        let actionIdA1: GlobalActionId? = .init(sceneLifetimeId: sceneIdA)
        let actionIdA2: GlobalActionId? = .init(sceneLifetimeId: sceneIdA)
        let actionIdB: GlobalActionId? = .init(sceneLifetimeId: sceneIdB)

        XCTAssertTrue(actionIdA1.isMatch(actionIdA2), "同じscene同士はtrue")
        XCTAssertFalse(actionIdA1.isMatch(actionIdB), "違うsceneならfalse")
        XCTAssertTrue(actionIdA1.isMatch(nil), "どちらかがnilならtrue")
        XCTAssertTrue(GlobalActionId?(nil).isMatch(actionIdA1), "どちらかがnilならtrue")

        let actionIdA100a: GlobalActionId? = .init(accountLifetimeId: .init(scene: sceneIdA, accountId: 100))
        let actionIdA100b: GlobalActionId? = .init(accountLifetimeId: .init(scene: sceneIdA, accountId: 100))
        let actionIdA200: GlobalActionId? = .init(accountLifetimeId: .init(scene: sceneIdA, accountId: 200))
        let actionIdB100: GlobalActionId? = .init(accountLifetimeId: .init(scene: sceneIdB, accountId: 100))

        XCTAssertTrue(actionIdA100a.isMatch(actionIdA100b), "sceneとaccountが一致すればtrue")
        XCTAssertFalse(actionIdA100a.isMatch(actionIdA200), "sceneが一致してもaccountが違えばfalse")
        XCTAssertFalse(actionIdA100a.isMatch(actionIdB100), "accountが一致してもsceneが違えばfalse")
    }
}
