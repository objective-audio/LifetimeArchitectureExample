//
//  RootLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

@MainActor
class RootLifecycleTests: XCTestCase {
    private var sceneLifetimeId: SceneLifetimeId!

    @MainActor
    override func setUpWithError() throws {
        self.sceneLifetimeId = .init(instanceId: .init())
    }

    @MainActor
    override func tearDownWithError() throws {
        self.sceneLifetimeId = nil
    }

    func testSwitch() {
        let lifecycle = RootLifecycle<EmptyLifetimeAccessor>(sceneLifetimeId: self.sceneLifetimeId)

        XCTAssertNil(lifecycle.current)

        lifecycle.switchToLaunch()

        guard case .launch = lifecycle.current else {
            XCTFail("currentの内容が不正")
            return
        }

        lifecycle.switchToLogin()

        guard case .login = lifecycle.current else {
            XCTFail("currentの内容が不正")
            return
        }

        lifecycle.switchToAccount(account: .init(id: 123, name: "test-name-123"))

        guard case .account = lifecycle.current else {
            XCTFail("currentの内容が不正")
            return
        }
    }
}
