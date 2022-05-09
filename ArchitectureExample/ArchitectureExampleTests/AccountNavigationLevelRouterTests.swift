//
//  AccountNavigationLevelRouterTests.swift
//

import XCTest
@testable import ArchitectureExample

@MainActor
class AccountNavigationLevelRouterTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testPushAndPop() {
        let router = AccountNavigationLevelRouter()
        
        var calledStacks: [[AccountNavigationSubLevel]] = []
        
        let canceller = router.$levels.sink { stack in
            calledStacks.append(stack)
        }
        
        XCTContext.runActivity(named: "初期状態は空") { _ in
            XCTAssertEqual(router.levels.count, 0)
            XCTAssertEqual(calledStacks.count, 1)
            XCTAssertEqual(calledStacks[0].count, 0)
        }
        
        XCTContext.runActivity(named: "menuがなければinfoはpushできない") { _ in
            router.pushInfo(uiSystem: .swiftUI)
            
            XCTAssertEqual(router.levels.count, 0)
            XCTAssertEqual(calledStacks.count, 1)
        }
        
        XCTContext.runActivity(named: "空ならmenuをpushできる") { _ in
            router.pushMenu()
            
            XCTAssertEqual(router.levels.count, 1)
            guard case .menu = router.levels[0] else {
                XCTFail()
                return
            }
            XCTAssertEqual(calledStacks.count, 2)
            XCTAssertEqual(calledStacks[1].count, 1)
        }
        
        XCTContext.runActivity(named: "menuがあればinfoをpushできる") { _ in
            router.pushInfo(uiSystem: .swiftUI)
            
            XCTAssertEqual(router.levels.count, 2)
            guard case .menu = router.levels[0],
                  case .info(let level) = router.levels[1],
                  level.uiSystem == .swiftUI else {
                XCTFail()
                return
            }
            XCTAssertEqual(calledStacks.count, 3)
            XCTAssertEqual(calledStacks[2].count, 2)
        }
        
        XCTContext.runActivity(named: "infoがあれば何もpushできない") { _ in
            router.pushMenu()
            router.pushInfo(uiSystem: .swiftUI)
            router.pushInfo(uiSystem: .uiKit)
            
            XCTAssertEqual(router.levels.count, 2)
            XCTAssertEqual(calledStacks.count, 3)
        }
        
        XCTContext.runActivity(named: "infoがあればinfoをpopできる") { _ in
            router.popInfo()
            
            XCTAssertEqual(router.levels.count, 1)
            guard case .menu = router.levels[0] else {
                XCTFail()
                return
            }
            XCTAssertEqual(calledStacks.count, 4)
            XCTAssertEqual(calledStacks[3].count, 1)
        }
        
        XCTContext.runActivity(named: "menuだけがあればinfoをpushできる") { _ in
            router.pushInfo(uiSystem: .uiKit)
            
            XCTAssertEqual(router.levels.count, 2)
            guard case .menu = router.levels[0],
                  case .info(let level) = router.levels[1],
                  level.uiSystem == .uiKit else {
                XCTFail()
                return
            }
            XCTAssertEqual(calledStacks.count, 5)
            XCTAssertEqual(calledStacks[4].count, 2)
        }
        
        canceller.cancel()
    }
}
