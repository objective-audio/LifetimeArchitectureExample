//
//  AccountNavigationLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

@MainActor
class AccountNavigationLifecycleTests: XCTestCase {
    private var accountLifetimeId: AccountLifetimeId!
    private var idGenerator: InstanceIdGeneratorStub!

    @MainActor
    override func setUpWithError() throws {
        self.accountLifetimeId = AccountLifetimeId(scene: .init(instanceId: .init()),
                                                   accountId: 1)
        self.idGenerator = .init()
    }

    @MainActor
    override func tearDownWithError() throws {
        self.accountLifetimeId = nil
        self.idGenerator = nil
    }

    func testPushAndPop() {
        let lifecycle = AccountNavigationLifecycle<EmptyLifetimeAccessor>(accountLifetimeId: self.accountLifetimeId,
                                                                          idGenerator: self.idGenerator)

        var calledStacks: [[AccountNavigationSubLifetime]] = []

        let canceller = lifecycle.$stack.sink { stack in
            calledStacks.append(stack)
        }

        XCTContext.runActivity(named: "初期状態は空") { _ in
            XCTAssertEqual(lifecycle.stack.count, 0)
            XCTAssertEqual(calledStacks.count, 1)
            XCTAssertEqual(calledStacks[0].count, 0)
        }

        XCTContext.runActivity(named: "menuがなければinfoはpushできない") { _ in
            lifecycle.pushInfo(uiSystem: .swiftUI)

            XCTAssertEqual(lifecycle.stack.count, 0)
            XCTAssertEqual(calledStacks.count, 1)
            XCTAssertEqual(self.idGenerator.genarated.count, 0)
        }

        XCTContext.runActivity(named: "空ならmenuをpushできる") { _ in
            lifecycle.pushMenu()

            XCTAssertEqual(lifecycle.stack.count, 1)

            guard case .menu = lifecycle.stack[0] else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 2)
            XCTAssertEqual(calledStacks[1].count, 1)
            XCTAssertEqual(self.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "menuがあればinfoをpushできる") { _ in
            lifecycle.pushInfo(uiSystem: .swiftUI)

            XCTAssertEqual(lifecycle.stack.count, 2)
            guard case .menu = lifecycle.stack[0],
                  case .info(let lifetime) = lifecycle.stack[1],
                  lifetime.interactor.uiSystem == .swiftUI else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 3)
            XCTAssertEqual(calledStacks[2].count, 2)
            XCTAssertEqual(self.idGenerator.genarated.count, 2)
        }

        XCTContext.runActivity(named: "infoがあれば何もpushできない") { _ in
            lifecycle.pushMenu()
            lifecycle.pushInfo(uiSystem: .swiftUI)
            lifecycle.pushInfo(uiSystem: .uiKit)

            XCTAssertEqual(lifecycle.stack.count, 2)
            XCTAssertEqual(calledStacks.count, 3)
            XCTAssertEqual(self.idGenerator.genarated.count, 2)
        }

        XCTContext.runActivity(named: "lifetimeIdが一致しなければinfoをpopできない") { _ in
            lifecycle.popInfo(lifetimeId: .init(instanceId: .init(),
                                                account: self.accountLifetimeId))

            XCTAssertEqual(lifecycle.stack.count, 2)
            XCTAssertEqual(calledStacks.count, 3)
            XCTAssertEqual(self.idGenerator.genarated.count, 2)
        }

        XCTContext.runActivity(named: "lifetimeIdが一致すればinfoをpopできる") { _ in
            lifecycle.popInfo(lifetimeId: .init(instanceId: self.idGenerator.genarated[1],
                                                account: self.accountLifetimeId))

            XCTAssertEqual(lifecycle.stack.count, 1)
            guard case .menu = lifecycle.stack[0] else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 4)
            XCTAssertEqual(calledStacks[3].count, 1)
            XCTAssertEqual(self.idGenerator.genarated.count, 2)
        }

        XCTContext.runActivity(named: "menuだけがあればinfoをpushできる") { _ in
            lifecycle.pushInfo(uiSystem: .uiKit)

            XCTAssertEqual(lifecycle.stack.count, 2)
            guard case .menu = lifecycle.stack[0],
                  case .info(let lifetime) = lifecycle.stack[1],
                  lifetime.interactor.uiSystem == .uiKit else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 5)
            XCTAssertEqual(calledStacks[4].count, 2)
            XCTAssertEqual(self.idGenerator.genarated.count, 3)
        }

        canceller.cancel()
    }
}
