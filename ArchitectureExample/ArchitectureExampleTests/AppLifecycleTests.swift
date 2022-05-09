//
//  AppLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

@MainActor
class AppLifecycleTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testAdd() {
        let lifecycle = AppLifecycle<EmptyLifetimeAccessor>()

        var called: [AppLifetime<EmptyLifetimeAccessor>?] = []

        let canceller = lifecycle.$lifetime.sink {
            called.append($0)
        }

        XCTContext.runActivity(named: "初期状態はnil") { _ in
            XCTAssertNil(lifecycle.lifetime)
            XCTAssertEqual(called.count, 1)
            XCTAssertNil(called[0])
        }

        XCTContext.runActivity(named: "add()を呼ぶとlifetimeが追加される") { _ in
            lifecycle.add()

            XCTAssertNotNil(lifecycle.lifetime)
            XCTAssertEqual(called.count, 2)
            XCTAssertNotNil(called[1])
        }

        XCTContext.runActivity(named: "重ねてadd()を呼んでも何もしない") { _ in
            lifecycle.add()

            XCTAssertEqual(called.count, 2)
        }

        canceller.cancel()
    }
}
