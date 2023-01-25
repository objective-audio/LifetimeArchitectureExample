//
//  AccountNavigationLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

private struct AccountMenuLifetimeStub: AccountMenuLifetimeForLifecycle {
    let lifetimeId: AccountMenuLifetimeId
    var interactor: AccountMenuInteractor { fatalError() }
}

private struct AccountInfoLifetimeStub: AccountInfoLifetimeForLifecycle {
    let lifetimeId: AccountInfoLifetimeId
    let uiSystem: UISystem
    var interactor: AccountInfoInteractor { fatalError() }
}

private struct AccountDetailLifetimeStub: AccountDetailLifetimeForLifecycle {
    let lifetimeId: AccountDetailLifetimeId
    var interactor: AccountDetailInteractor { fatalError() }
}

private struct FactoryStub: FactoryForAccountNavigationLifecycle {
    static func makeAccountMenuLifetime(
        lifetimeId: AccountMenuLifetimeId,
        navigationLifecycle: AccountNavigationLifecycle<Self>
    ) -> AccountMenuLifetimeStub {
        AccountMenuLifetimeStub(lifetimeId: lifetimeId)
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
        let lifecycle = AccountNavigationLifecycle<FactoryStub>(accountLifetimeId: self.accountLifetimeId,
                                                                          idGenerator: self.idGenerator)

        var calledStacks: [[AccountNavigationSubLifetime<FactoryStub>]] = []

        let canceller = lifecycle.$stack.sink { stack in
            calledStacks.append(stack)
        }

        XCTContext.runActivity(named: "初期状態はmenu") { _ in
            XCTAssertEqual(lifecycle.stack.count, 1)

            guard case .menu = lifecycle.stack[0] else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 1)
            XCTAssertEqual(calledStacks[0].count, 1)
            XCTAssertEqual(self.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "menuがあればinfoをpushできる") { _ in
            lifecycle.pushInfo(uiSystem: .swiftUI)

            XCTAssertEqual(lifecycle.stack.count, 2)
            guard case .menu = lifecycle.stack[0],
                  case .info(let lifetime) = lifecycle.stack[1],
                  lifetime.uiSystem == .swiftUI else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 2)
            XCTAssertEqual(calledStacks[1].count, 2)
            XCTAssertEqual(self.idGenerator.genarated.count, 2)
        }

        XCTContext.runActivity(named: "infoがあれば何もpushできない") { _ in
            lifecycle.pushInfo(uiSystem: .swiftUI)
            lifecycle.pushInfo(uiSystem: .uiKit)

            XCTAssertEqual(lifecycle.stack.count, 2)
            XCTAssertEqual(calledStacks.count, 2)
            XCTAssertEqual(self.idGenerator.genarated.count, 2)
        }

        XCTContext.runActivity(named: "lifetimeIdが一致しなければinfoをpopできない") { _ in
            lifecycle.popInfo(lifetimeId: .init(instanceId: .init(),
                                                account: self.accountLifetimeId))

            XCTAssertEqual(lifecycle.stack.count, 2)
            XCTAssertEqual(calledStacks.count, 2)
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
            XCTAssertEqual(calledStacks.count, 3)
            XCTAssertEqual(calledStacks[2].count, 1)
            XCTAssertEqual(self.idGenerator.genarated.count, 2)
        }

        XCTContext.runActivity(named: "menuだけがあればinfoをpushできる") { _ in
            lifecycle.pushInfo(uiSystem: .uiKit)

            XCTAssertEqual(lifecycle.stack.count, 2)
            guard case .menu = lifecycle.stack[0],
                  case .info(let lifetime) = lifecycle.stack[1],
                  lifetime.uiSystem == .uiKit else {
                XCTFail("invalid lifetime stack.")
                return
            }
            XCTAssertEqual(calledStacks.count, 4)
            XCTAssertEqual(calledStacks[3].count, 2)
            XCTAssertEqual(self.idGenerator.genarated.count, 3)
        }

        #warning("todo detailへのpushをテストする")

        canceller.cancel()
    }
}
