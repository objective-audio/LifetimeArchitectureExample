//
//  AccountEditModalLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

private struct AccountEditAlertLifetimeStub: AccountEditAlertLifetimeForLifecycle {
    let lifetimeId: ArchitectureExample.AccountEditAlertLifetimeId
    let alertId: ArchitectureExample.AccountEditAlertId
    var interactor: ArchitectureExample.AccountEditAlertInteractor { fatalError() }
    var receiver: ArchitectureExample.AccountEditAlertReceiver { fatalError() }
}

private struct FactoryStub: FactoryForAccountEditModalLifecycle {
    static func makeAccountEditAlertLifetime(lifetimeId: AccountEditAlertLifetimeId,
                                             alertId: AccountEditAlertId) -> AccountEditAlertLifetimeStub {
        .init(lifetimeId: lifetimeId, alertId: alertId)
    }
}

@MainActor
class AccountEditModalLifecycleTests: XCTestCase {
    private var accountEditLifetimeId: AccountEditLifetimeId!
    private var idGenerator: InstanceIdGeneratorStub!

    @MainActor
    override func setUpWithError() throws {
        self.accountEditLifetimeId = .init(instanceId: .init(),
                                           account: .init(scene: .init(instanceId: .init()),
                                                          accountId: 123))
        self.idGenerator = .init()
    }

    @MainActor
    override func tearDownWithError() throws {
        self.accountEditLifetimeId = nil
        self.idGenerator = nil
    }

    func testAddAndRemoveAlert() throws {
        let lifecycle = AccountEditModalLifecycle<FactoryStub>(lifetimeId: self.accountEditLifetimeId,
                                                               idGenerator: self.idGenerator)

        var called: [AccountEditModalSubLifetime<FactoryStub>?] = []

        let canceller = lifecycle.$current.sink { lifetime in
            called.append(lifetime)
        }

        XCTAssertNil(lifecycle.current)
        XCTAssertEqual(called.count, 1)
        XCTAssertNil(called[0])

        XCTContext.runActivity(named: "currentがnilでremoveAlertを呼んでも何もしない") { _ in
            lifecycle.removeAlert(lifetimeId: .init(instanceId: .init(),
                                                    accountEdit: self.accountEditLifetimeId))

            XCTAssertEqual(called.count, 1)
            XCTAssertEqual(self.idGenerator.genarated.count, 0)
        }

        XCTContext.runActivity(named: "currentがnilでaddAlertを呼んでcurrentが更新される") { _ in
            lifecycle.addAlert(id: .destruct)

            guard let current = lifecycle.current,
                  case .alert(let lifetime) = current,
                  lifetime.alertId == .destruct else {
                XCTFail("currentが不正")
                return
            }

            XCTAssertEqual(called.count, 2)

            guard case .alert(let lifetime) = called[1],
                  lifetime.alertId == .destruct else {
                XCTFail("currentが不正")
                return
            }

            XCTAssertEqual(self.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "currentがあるときにaddAlertを呼んでも何もしない") { _ in
            lifecycle.addAlert(id: .destruct)

            XCTAssertEqual(called.count, 2)
            XCTAssertEqual(self.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "addされているものと違うlifetimeIdでremoveを呼んでも何もしない") { _ in
            lifecycle.removeAlert(lifetimeId: .init(instanceId: .init(),
                                                    accountEdit: self.accountEditLifetimeId))

            XCTAssertEqual(called.count, 2)
            XCTAssertEqual(self.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "addされているものと一致するidでremoveを呼ぶとcurrentがnilになる") { _ in
            guard let current = lifecycle.current,
                  case .alert(let lifetime) = current else {
                XCTFail("currentが不正")
                return
            }

            lifecycle.removeAlert(lifetimeId: lifetime.lifetimeId)

            XCTAssertNil(lifecycle.current)
            XCTAssertEqual(called.count, 3)
            XCTAssertNil(called[2])
            XCTAssertEqual(self.idGenerator.genarated.count, 1)
        }

        canceller.cancel()
    }
}
