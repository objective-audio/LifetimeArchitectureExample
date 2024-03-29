//
//  RootModalLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

private struct AccountEditLifetimeStub: AccountEditLifetimeForLifecycle {
    let lifetimeId: AccountEditLifetimeId
    var interactor: AccountEditInteractor { fatalError() }
    var modalLifecycle: AccountEditModalLifecycle<AccountEditModalFactory> { fatalError() }
    var receiver: AccountEditReceiver { fatalError() }
}

private struct RootAlertLifetimeStub: RootAlertLifetimeForLifecycle {
    let lifetimeId: RootAlertLifetimeId
    let alertId: RootAlertId
    var interactor: RootAlertInteractor { fatalError() }
    var receiver: RootAlertReceiver { fatalError() }
}

private enum FactoryStub: FactoryForRootModalLifecycle {
    static var idGenerator: InstanceIdGenerator!
    static func makeInstanceId() -> InstanceId {
        self.idGenerator.generate()
    }

    static func makeAccountEditLifetime(lifetimeId: AccountEditLifetimeId) -> AccountEditLifetimeStub {
        .init(lifetimeId: lifetimeId)
    }

    static func makeRootAlertLifetime(lifetimeId: RootAlertLifetimeId,
                                      alertId: RootAlertId) -> RootAlertLifetimeStub {
        .init(lifetimeId: lifetimeId, alertId: alertId)
    }
}

@MainActor
class RootModalLifecycleTests: XCTestCase {
    private var sceneLifetimeId: SceneLifetimeId!

    @MainActor
    override func setUpWithError() throws {
        self.sceneLifetimeId = .init(instanceId: .init())
        FactoryStub.idGenerator = .init()
    }

    @MainActor
    override func tearDownWithError() throws {
        self.sceneLifetimeId = nil
        FactoryStub.idGenerator = nil
    }

    func testAddAndRemoveAlert() throws {
        let lifecycle = RootModalLifecycle<FactoryStub>(sceneLifetimeId: self.sceneLifetimeId)

        var called: [RootModalSubLifetime<FactoryStub>?] = []

        let canceller = lifecycle.$current.sink { lifetime in
            called.append(lifetime)
        }

        XCTAssertNil(lifecycle.current)
        XCTAssertEqual(called.count, 1)
        XCTAssertNil(called[0])

        XCTContext.runActivity(named: "currentがnilなのでhideを呼んでも何もしない") { _ in
            lifecycle.removeAlert(lifetimeId: .init(instanceId: .init(),
                                                    scene: self.sceneLifetimeId))

            XCTAssertEqual(called.count, 1)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 0)
        }

        XCTContext.runActivity(named: "currentがnilでaddを呼んだらcurrentが更新される") { _ in
            lifecycle.addAlert(id: .loginFailed(.other))

            guard let current = lifecycle.current,
                  case .alert(let lifetime) = current,
                  lifetime.alertId == .loginFailed(.other) else {
                XCTFail("currentの内容が不正")
                return
            }

            XCTAssertEqual(called.count, 2)

            guard let subLifetime = called[1],
                  case .alert(let lifetime) = subLifetime,
                  lifetime.alertId == .loginFailed(.other) else {
                XCTFail("currentの内容が不正")
                return
            }

            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "currentがあるときにaddを呼んでも何もしない") { _ in
            lifecycle.addAlert(id: .loginFailed(.other))

            XCTAssertEqual(called.count, 2)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "addされているalertと違うlifetimeIdでremoveしようとしても何もしない") { _ in
            lifecycle.removeAlert(lifetimeId: .init(instanceId: .init(),
                                                    scene: self.sceneLifetimeId))

            XCTAssertEqual(called.count, 2)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "addされているalertをremoveしたらcurrentがnilになる") { _ in
            guard let current = lifecycle.current,
                  case .alert = current else {
                XCTFail("currentが不正")
                return
            }

            let lifetimeId = RootAlertLifetimeId(instanceId: FactoryStub.idGenerator.genarated[0],
                                                 scene: self.sceneLifetimeId)
            lifecycle.removeAlert(lifetimeId: lifetimeId)

            XCTAssertNil(lifecycle.current)
            XCTAssertEqual(called.count, 3)
            XCTAssertNil(called[2])
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        canceller.cancel()
    }

    func testAddAndRemoveAccountEdit() throws {
        let accountLifetimeId = AccountLifetimeId(scene: self.sceneLifetimeId,
                                                  accountId: 123)

        let lifecycle = RootModalLifecycle<FactoryStub>(sceneLifetimeId: self.sceneLifetimeId)

        var called: [RootModalSubLifetime<FactoryStub>?] = []

        let canceller = lifecycle.$current.sink { lifetime in
            called.append(lifetime)
        }

        XCTAssertNil(lifecycle.current)
        XCTAssertEqual(called.count, 1)
        XCTAssertNil(called[0])

        XCTContext.runActivity(named: "currentがnilなのでremoveを呼んでも何もしない") { _ in
            lifecycle.removeAccountEdit(lifetimeId: .init(instanceId: .init(),
                                                          account: accountLifetimeId))

            XCTAssertEqual(called.count, 1)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 0)
        }

        XCTContext.runActivity(named: "currentがnilでaddを呼んだらcurrentが更新される") { _ in
            lifecycle.addAccountEdit(accountLifetimeId: accountLifetimeId)

            guard let current = lifecycle.current,
                  case .accountEdit(let lifetime) = current,
                  lifetime.lifetimeId.account == accountLifetimeId else {
                XCTFail("currentの内容が不正")
                return
            }

            XCTAssertEqual(called.count, 2)

            guard let subLifetime = called[1],
                  case .accountEdit(let lifetime) = subLifetime,
                  lifetime.lifetimeId.account == accountLifetimeId else {
                XCTFail("currentの内容が不正")
                return
            }

            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "currentがあるときにaddを呼んでも何もしない") { _ in
            lifecycle.addAccountEdit(accountLifetimeId: accountLifetimeId)

            XCTAssertEqual(called.count, 2)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "addされているものと違うlifetimeIdでremoveを呼んでも何もしない") { _ in
            guard let current = lifecycle.current,
                  case .accountEdit = current else {
                XCTFail("currentが不正")
                return
            }

            let otherId = AccountEditLifetimeId(instanceId: .init(),
                                                account: .init(scene: self.sceneLifetimeId,
                                                               accountId: 234))
            lifecycle.removeAccountEdit(lifetimeId: otherId)

            XCTAssertEqual(called.count, 2)
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        XCTContext.runActivity(named: "addされているものをremoveしたらcurrentがnilになる") { _ in
            guard let current = lifecycle.current,
                  case .accountEdit(let lifetime) = current else {
                XCTFail("currentが不正")
                return
            }

            lifecycle.removeAccountEdit(lifetimeId: lifetime.lifetimeId)

            XCTAssertNil(lifecycle.current)
            XCTAssertEqual(called.count, 3)
            XCTAssertNil(called[2])
            XCTAssertEqual(FactoryStub.idGenerator.genarated.count, 1)
        }

        canceller.cancel()
    }
}
