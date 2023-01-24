//
//  AccountInfoInteractorTests.swift
//

import XCTest
import Combine
@testable import ArchitectureExample

private class AccountHolderStub: AccountInfoInteractor.AccountHolder {
    @CurrentValue var name: String = ""

    var namePublisher: AnyPublisher<String, Never> {
        self.$name.eraseToAnyPublisher()
    }
}

private class AccountNavigationLifecycleStub: AccountInfoInteractor.NavigationLifecycle {
    var canPopInfoHandler: (AccountInfoLifetimeId) -> Bool = { _ in true }
    var popInfoHandler: (AccountInfoLifetimeId) -> Void = { _ in }
    var pushDetailHandler: () -> Void = {}

    func canPopInfo(lifetimeId: AccountInfoLifetimeId) -> Bool {
        self.canPopInfoHandler(lifetimeId)
    }

    func popInfo(lifetimeId: AccountInfoLifetimeId) {
        self.popInfoHandler(lifetimeId)
    }

    func pushDetail() {
        self.pushDetailHandler()
    }
}

private class RootModalLifecycleStub: AccountInfoInteractor.RootModalLifecycle {
    var addHandler: (AccountLifetimeId) -> Void  = { _ in }

    func addAccountEdit(accountLifetimeId: AccountLifetimeId) {
        self.addHandler(accountLifetimeId)
    }
}

@MainActor
class AccountInfoInteractorTests: XCTestCase {
    private var lifetimeId: AccountInfoLifetimeId!
    private var accountHolder: AccountHolderStub!
    private var navigationLifecycle: AccountNavigationLifecycleStub!
    private var rootModalLifecycle: RootModalLifecycleStub!
    private var interactor: AccountInfoInteractor!

    @MainActor
    override func setUpWithError() throws {
        self.lifetimeId = .init(instanceId: .init(),
                                account: .init(scene: .init(instanceId: .init()),
                                               accountId: 1))

        self.accountHolder = .init()
        self.navigationLifecycle = .init()
        self.rootModalLifecycle = .init()

        self.interactor = .init(uiSystem: .swiftUI,
                                lifetimeId: self.lifetimeId,
                                accountHolder: self.accountHolder,
                                navigationLifecycle: self.navigationLifecycle,
                                rootModalLifecycle: self.rootModalLifecycle)
    }

    @MainActor
    override func tearDownWithError() throws {
        self.lifetimeId = nil
        self.accountHolder = nil
        self.navigationLifecycle = nil
        self.rootModalLifecycle = nil
        self.interactor = nil
    }

    func testInit() {
        XCTAssertEqual(self.interactor.uiSystem, .swiftUI)
        XCTAssertEqual(self.interactor.accountId, 1)
    }

    func testNamePublisher() {
        var called: [String] = []

        let canceller = self.interactor.namePublisher.sink { name in
            called.append(name)
        }

        XCTAssertEqual(called.count, 1)
        XCTAssertEqual(called[0], "")

        self.accountHolder.name = "test-name"

        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[1], "test-name")

        canceller.cancel()
    }

    func testEditAccount() {
        var called: [AccountLifetimeId] = []

        self.rootModalLifecycle.addHandler = { id in
            called.append(id)
        }

        XCTAssertEqual(called.count, 0)

        self.interactor.editAccount()

        XCTAssertEqual(called.count, 1)

        self.interactor.editAccount()

        XCTAssertEqual(called.count, 2, "複数回呼べる")
    }

    func testFinalize() {
        var called: [AccountInfoLifetimeId] = []

        self.navigationLifecycle.popInfoHandler = {
            called.append($0)
        }

        XCTAssertEqual(called.count, 0)

        self.interactor.finalize()

        XCTAssertEqual(called.count, 1)
        XCTAssertEqual(called[0], self.lifetimeId)

        self.interactor.finalize()

        XCTAssertEqual(called.count, 1, "複数回呼んでも無視される")
    }
}
