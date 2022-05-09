//
//  AppLevelRouterTests.swift
//

import XCTest
@testable import ArchitectureExample

@MainActor
class AppLevelRouterTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testAddLevel() {
        let router = AppLevelRouter<EmptyLevelAccessor>()
        
        var called: [AppLevel<EmptyLevelAccessor>?] = []
        
        let canceller = router.$level.sink {
            called.append($0)
        }
        
        XCTContext.runActivity(named: "初期状態はnil") { _ in
            XCTAssertNil(router.level)
            XCTAssertEqual(called.count, 1)
            XCTAssertNil(called[0])
        }
        
        XCTContext.runActivity(named: "addLevelを呼ぶとlevelが追加される") { _ in
            router.addLevel()
            
            XCTAssertNotNil(router.level)
            XCTAssertEqual(called.count, 2)
            XCTAssertNotNil(called[1])
        }
        
        XCTContext.runActivity(named: "重ねてaddLevelを呼んでも何もしない") { _ in
            router.addLevel()
            
            XCTAssertEqual(called.count, 2)
        }
        
        canceller.cancel()
    }
}
