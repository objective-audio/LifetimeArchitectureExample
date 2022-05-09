//
//  SceneLevelRouterTests.swift
//

import XCTest
@testable import ArchitectureExample

@MainActor
class SceneLevelRouterTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testAppendAndRemove() throws {
        let router = SceneLevelRouter<EmptyLevelAccessor>()
        
        let idA = SceneLevelId(instanceId: .init())
        let idB = SceneLevelId(instanceId: .init())
        
        XCTContext.runActivity(named: "初期状態はなし") { _ in
            XCTAssertNil(router.level(id: idA))
            XCTAssertNil(router.level(id: idB))
            XCTAssertNil(router.index(of: idA))
            XCTAssertNil(router.index(of: idB))
        }
        
        XCTContext.runActivity(named: "sceneAを追加しIndex0に保持") { _ in
            router.append(id: idA)
            
            XCTAssertNotNil(router.level(id: idA))
            XCTAssertNil(router.level(id: idB))
            XCTAssertEqual(router.index(of: idA), 0)
            XCTAssertNil(router.index(of: idB))
        }
        
        try XCTContext.runActivity(named: "追加されたAppLevelはlaunchの状態になっている") { _ in
            let level = try XCTUnwrap(router.level(id: idA))
            XCTAssertTrue(level.rootRouter.isLaunch)
        }
        
        XCTContext.runActivity(named: "sceneBを追加しIndex1に保持") { _ in
            router.append(id: idB)
            
            XCTAssertNotNil(router.level(id: idA))
            XCTAssertNotNil(router.level(id: idB))
            XCTAssertEqual(router.index(of: idA), 0)
            XCTAssertEqual(router.index(of: idB), 1)
        }
        
        XCTContext.runActivity(named: "sceneAを削除しsceneBがIndex0になる") { _ in
            router.remove(id: idA)
            
            XCTAssertNil(router.level(id: idA))
            XCTAssertNotNil(router.level(id: idB))
            XCTAssertNil(router.index(of: idA))
            XCTAssertEqual(router.index(of: idB), 0)
        }
        
        XCTContext.runActivity(named: "sceneBを削除し全てクリア") { _ in
            router.remove(id: idB)
            
            XCTAssertNil(router.level(id: idA))
            XCTAssertNil(router.level(id: idB))
            XCTAssertNil(router.index(of: idA))
            XCTAssertNil(router.index(of: idB))
        }
    }
}
