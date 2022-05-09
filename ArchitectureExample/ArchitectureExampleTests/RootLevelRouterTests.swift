//
//  RootLevelRouterTests.swift
//

import XCTest
@testable import ArchitectureExample

@MainActor
class RootLevelRouterTests: XCTestCase {
    private var sceneLevelId: SceneLevelId!

    @MainActor
    override func setUpWithError() throws {
        self.sceneLevelId = .init(instanceId: .init())
    }

    @MainActor
    override func tearDownWithError() throws {
        self.sceneLevelId = nil
    }

    func testSwitch() {
        let rootRouter = RootLevelRouter<EmptyLevelAccessor>(sceneLevelId: self.sceneLevelId)
        
        XCTAssertNil(rootRouter.current)
        
        rootRouter.switchToLaunch()
        
        guard case .launch = rootRouter.current else {
            XCTFail()
            return
        }
        
        rootRouter.switchToLogin()
        
        guard case .login = rootRouter.current else {
            XCTFail()
            return
        }
        
        rootRouter.switchToAccount(account: .init(id: 123, name: "test-name-123"))
        
        guard case .account = rootRouter.current else {
            XCTFail()
            return
        }
    }
}
