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
        let sceneIdA = SceneLifetimeId(instanceId: .init())
        let sceneIdB = SceneLifetimeId(instanceId: .init())

        let actionIdA1: ActionId? = .init(sceneLifetimeId: sceneIdA)
        let actionIdA2: ActionId? = .init(sceneLifetimeId: sceneIdA)
        let actionIdB: ActionId? = .init(sceneLifetimeId: sceneIdB)

        XCTAssertTrue(actionIdA1.isMatch(actionIdA2), "同じscene同士はtrue")
        XCTAssertFalse(actionIdA1.isMatch(actionIdB), "違うsceneならfalse")
        XCTAssertTrue(actionIdA1.isMatch(nil), "どちらかがnilならtrue")
        XCTAssertTrue(ActionId?(nil).isMatch(actionIdA1), "どちらかがnilならtrue")

        let actionIdA100a: ActionId? = .init(accountLifetimeId: .init(scene: sceneIdA, accountId: 100))
        let actionIdA100b: ActionId? = .init(accountLifetimeId: .init(scene: sceneIdA, accountId: 100))
        let actionIdA200: ActionId? = .init(accountLifetimeId: .init(scene: sceneIdA, accountId: 200))
        let actionIdB100: ActionId? = .init(accountLifetimeId: .init(scene: sceneIdB, accountId: 100))

        XCTAssertTrue(actionIdA100a.isMatch(actionIdA100b), "sceneとaccountが一致すればtrue")
        XCTAssertFalse(actionIdA100a.isMatch(actionIdA200), "sceneが一致してもaccountが違えばfalse")
        XCTAssertFalse(actionIdA100a.isMatch(actionIdB100), "accountが一致してもsceneが違えばfalse")
    }
}
