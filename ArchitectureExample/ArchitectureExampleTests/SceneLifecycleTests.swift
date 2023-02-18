//
//  SceneLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

private struct SceneLifetimeStub: SceneLifetimeForLifecycle {
    let lifetimeId: SceneLifetimeId
    var rootLifecycle: RootLifecycle<RootFactory> { fatalError() }
    var rootModalLifecycle: RootModalLifecycle<RootModalFactory> { fatalError() }
}

private enum FactoryStub: FactoryForSceneLifecycle {
    static func makeSceneLifetime(id: SceneLifetimeId) -> SceneLifetimeStub {
        .init(lifetimeId: id)
    }
}

@MainActor
class SceneLifecycleTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testAppendAndRemove() throws {
        let lifecycle = SceneLifecycle<FactoryStub>()

        let idA = SceneLifetimeId(uuid: .init())
        let idB = SceneLifetimeId(uuid: .init())

        XCTContext.runActivity(named: "初期状態はなし") { _ in
            XCTAssertNil(lifecycle.lifetime(id: idA))
            XCTAssertNil(lifecycle.lifetime(id: idB))
            XCTAssertNil(lifecycle.index(of: idA))
            XCTAssertNil(lifecycle.index(of: idB))
        }

        XCTContext.runActivity(named: "sceneAを追加しIndex0に保持") { _ in
            lifecycle.append(id: idA)

            XCTAssertNotNil(lifecycle.lifetime(id: idA))
            XCTAssertNil(lifecycle.lifetime(id: idB))
            XCTAssertEqual(lifecycle.index(of: idA), 0)
            XCTAssertNil(lifecycle.index(of: idB))
        }

        XCTContext.runActivity(named: "sceneBを追加しIndex1に保持") { _ in
            lifecycle.append(id: idB)

            XCTAssertNotNil(lifecycle.lifetime(id: idA))
            XCTAssertNotNil(lifecycle.lifetime(id: idB))
            XCTAssertEqual(lifecycle.index(of: idA), 0)
            XCTAssertEqual(lifecycle.index(of: idB), 1)
        }

        XCTContext.runActivity(named: "sceneAを削除しsceneBがIndex0になる") { _ in
            lifecycle.remove(id: idA)

            XCTAssertNil(lifecycle.lifetime(id: idA))
            XCTAssertNotNil(lifecycle.lifetime(id: idB))
            XCTAssertNil(lifecycle.index(of: idA))
            XCTAssertEqual(lifecycle.index(of: idB), 0)
        }

        XCTContext.runActivity(named: "sceneBを削除し全てクリア") { _ in
            lifecycle.remove(id: idB)

            XCTAssertNil(lifecycle.lifetime(id: idA))
            XCTAssertNil(lifecycle.lifetime(id: idB))
            XCTAssertNil(lifecycle.index(of: idA))
            XCTAssertNil(lifecycle.index(of: idB))
        }
    }
}
