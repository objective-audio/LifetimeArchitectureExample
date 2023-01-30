//
//  AppLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

private struct AppLifetimeStub: AppLifetimeForLifecycle {
    var sceneLifecycle: SceneLifecycle<SceneFactory> { fatalError() }
    var userDefaults: UserDefaults { fatalError() }
    var accountRepository: AccountRepository { fatalError() }
    var actionSender: ActionSender { fatalError() }
}

private enum FactoryStub: FactoryForAppLifecycle {
    static func makeAppLifetime() -> AppLifetimeStub {
        .init()
    }
}

@MainActor
class AppLifecycleTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testAdd() {
        let lifecycle = AppLifecycle<FactoryStub>()

        var called: [AppLifetimeStub?] = []

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
