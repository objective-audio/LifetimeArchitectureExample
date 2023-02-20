//
//  AccountNavigationLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

private struct AccountInfoLifetimeStub: AccountInfoLifetimeForLifecycle {
    let lifetimeId: AccountInfoLifetimeId
    let uiSystem: UISystem
    var interactor: AccountInfoInteractor { fatalError() }
}

private struct AccountDetailLifetimeStub: AccountDetailLifetimeForLifecycle {
    let lifetimeId: AccountDetailLifetimeId
    var interactor: AccountDetailInteractor { fatalError() }
}

private enum FactoryStub: FactoryForAccountNavigationLifecycle {
    static var idGenerator: InstanceIdGenerator!

    static func makeInstanceId() -> InstanceId {
        self.idGenerator.generate()
    }

    static func makeAccountInfoLifetime(lifetimeId: AccountInfoLifetimeId,
                                        uiSystem: UISystem) -> AccountInfoLifetimeStub {
        .init(lifetimeId: lifetimeId, uiSystem: uiSystem)
    }

    static func makeAccountDetailLifetime(lifetimeId: AccountDetailLifetimeId) -> AccountDetailLifetimeStub {
        .init(lifetimeId: lifetimeId)
    }
}

@MainActor
class AccountNavigationLifecycleTests: XCTestCase {
    private var accountLifetimeId: AccountLifetimeId!

    @MainActor
    override func setUpWithError() throws {
        self.accountLifetimeId = AccountLifetimeId(scene: .init(uuid: .init()),
                                                   accountId: 1)
        FactoryStub.idGenerator = .init()
    }

    @MainActor
    override func tearDownWithError() throws {
        self.accountLifetimeId = nil
    }

    func testPushAndPop() {
        let lifecycle = AccountNavigationLifecycle(accountLifetimeId: self.accountLifetimeId,
                                                   factory: FactoryStub.self)

        var calledStacks: [[AccountNavigationSubLifetime<FactoryStub>]] = []

        let canceller = lifecycle.$stack.sink { stack in
            calledStacks.append(stack)
        }

        XCTContext.runActivity(named: "初期状態は空") { _ in
            XCTAssertTrue(lifecycle.stack.isEmpty)

            XCTAssertEqual(calledStacks.count, 1)
            XCTAssertEqual(calledStacks[0].count, 0)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 0)
        }

        XCTContext.runActivity(named: "空ならinfoをpushできる") { _ in
            lifecycle.pushInfo(uiSystem: .swiftUI)

            XCTAssertEqual(lifecycle.stack.count, 1)
            guard case .info(let lifetime) = lifecycle.stack[0],
                  lifetime.uiSystem == .swiftUI else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 2)
            XCTAssertEqual(calledStacks[1].count, 1)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "infoがあればinfoをpushできない") { _ in
            lifecycle.pushInfo(uiSystem: .swiftUI)
            lifecycle.pushInfo(uiSystem: .uiKit)

            XCTAssertEqual(lifecycle.stack.count, 1)
            XCTAssertEqual(calledStacks.count, 2)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "lifetimeIdが一致しなければinfoをpopできない") { _ in
            lifecycle.popInfo(lifetimeId: .init(instanceId: .init(),
                                                account: self.accountLifetimeId))

            XCTAssertEqual(lifecycle.stack.count, 1)
            XCTAssertEqual(calledStacks.count, 2)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "lifetimeIdが一致すればinfoをpopできる") { _ in
            lifecycle.popInfo(lifetimeId: .init(instanceId: FactoryStub.idGenerator.genarated[0],
                                                account: self.accountLifetimeId))

            XCTAssertEqual(lifecycle.stack.count, 0)
            XCTAssertEqual(calledStacks.count, 3)
            XCTAssertEqual(calledStacks[2].count, 0)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "空ならinfoをpushできる") { _ in
            lifecycle.pushInfo(uiSystem: .uiKit)

            XCTAssertEqual(lifecycle.stack.count, 1)
            guard case .info(let lifetime) = lifecycle.stack[0],
                  lifetime.uiSystem == .uiKit else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 4)
            XCTAssertEqual(calledStacks[3].count, 1)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 2)
        }

        XCTContext.runActivity(named: "infoだけがあればdetailをpushできる") { _ in
            lifecycle.pushDetail()

            XCTAssertEqual(lifecycle.stack.count, 2)
            guard case .info(let lifetime) = lifecycle.stack[0],
                  lifetime.uiSystem == .uiKit,
                  case .detail = lifecycle.stack[1] else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 5)
            XCTAssertEqual(calledStacks[4].count, 2)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 3)
        }

        XCTContext.runActivity(named: "lifetimeIdが一致してもdetailからはinfoをpopできない") { _ in
            lifecycle.popInfo(lifetimeId: .init(instanceId: FactoryStub.idGenerator.genarated[1],
                                                account: self.accountLifetimeId))

            XCTAssertEqual(lifecycle.stack.count, 2)
            XCTAssertEqual(calledStacks.count, 5)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 3)
        }

        XCTContext.runActivity(named: "lifetimeIdが一致していればdetailをpopできる") { _ in
            lifecycle.popDetail(lifetimeId: .init(instanceId: FactoryStub.idGenerator.genarated[2],
                                                  account: self.accountLifetimeId))

            XCTAssertEqual(lifecycle.stack.count, 1)
            guard case .info(let lifetime) = lifecycle.stack[0],
                  lifetime.uiSystem == .uiKit else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 6)
            XCTAssertEqual(calledStacks[5].count, 1)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 3)
        }

        canceller.cancel()
    }
}
