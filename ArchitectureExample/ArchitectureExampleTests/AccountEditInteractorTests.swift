//
//  AccountEditInteractorTests.swift
//

import XCTest
import Combine
@testable import ArchitectureExample

private class AccountHolderStub: AccountHolderForAccountEditInteractor {
    var name: String = ""
}

private class RootModalLifecycleStub: RootModalLifecycleForAccountEditInteractor {
    var removeHandler: (AccountEditLifetimeId) -> Void = { _ in }

    func removeAccountEdit(lifetimeId: AccountEditLifetimeId) {
        removeHandler(lifetimeId)
    }
}

private class AccountEditModalLifecycleStub: AccountEditModalLifecycleForAccountEditInteractor {
    var addHandler: (AccountEditAlertId) -> Void = { _ in }

    @CurrentValue var hasCurrent: Bool = false

    var hasCurrentPublisher: AnyPublisher<Bool, Never> {
        self.$hasCurrent.eraseToAnyPublisher()
    }

    func addAlert(id: AccountEditAlertId) {
        addHandler(id)
    }
}

private class ActionSenderStub: ActionSenderForAccountEditInteractor {
    func sendLogout(accountLifetimeId: AccountLifetimeId) {}
}

@MainActor
class AccountEditInteractorTests: XCTestCase {
    private var lifetimeId: AccountEditLifetimeId!
    private var accountHolder: AccountHolderStub!
    private var rootLifecycle: RootModalLifecycleStub!
    private var editModalLifecycle: AccountEditModalLifecycleStub!
    private var actionSender: ActionSenderStub!

    @MainActor
    override func setUpWithError() throws {
        self.lifetimeId = .init(instanceId: .init(),
                                account: .init(scene: .init(uuid: .init()),
                                               accountId: 123))
        self.accountHolder = .init()
        self.rootLifecycle = .init()
        self.editModalLifecycle = .init()
        self.actionSender = .init()
    }

    @MainActor
    override func tearDownWithError() throws {
        self.lifetimeId = nil
        self.accountHolder = nil
        self.rootLifecycle = nil
        self.editModalLifecycle = nil
        self.actionSender = nil
    }

    func testEditAndSave() {
        self.accountHolder.name = "original"

        enum Called: Equatable {
            case hide(AccountEditLifetimeId)
        }

        var called: [Called] = []

        self.rootLifecycle.removeHandler = { called.append(.hide($0)) }

        let interactor = self.makeInteractor()

        XCTContext.runActivity(named: "初期状態は保存できない") { _ in
            XCTAssertEqual(interactor.name, "original")
            XCTAssertFalse(interactor.isEdited)
        }

        XCTContext.runActivity(named: "save可能でなければsaveを呼んでも何もしない") { _ in
            interactor.save()
            XCTAssertEqual(called.count, 0)
        }

        XCTContext.runActivity(named: "nameを変更したら保存できる") { _ in
            interactor.name = "changed"

            XCTAssertTrue(interactor.isEdited)
            XCTAssertEqual(self.accountHolder.name, "original")
        }

        XCTContext.runActivity(named: "nameを戻したら保存できない") { _ in
            interactor.name = "original"

            XCTAssertFalse(interactor.isEdited)
        }

        XCTContext.runActivity(named: "nameを変更し保存して画面を閉じる") { _ in
            interactor.name = "test-name-234"

            XCTAssertTrue(interactor.isEdited)
            XCTAssertEqual(self.accountHolder.name, "original")
            XCTAssertEqual(called.count, 0)

            interactor.save()

            XCTAssertEqual(self.accountHolder.name, "test-name-234")
            XCTAssertEqual(called.count, 1)
            XCTAssertEqual(called[0], .hide(self.lifetimeId))
        }
    }
}

private extension AccountEditInteractorTests {
    func makeInteractor() -> AccountEditInteractor {
        AccountEditInteractor(lifetimeId: self.lifetimeId,
                              accountHolder: self.accountHolder,
                              rootModalLifecycle: self.rootLifecycle,
                              accountEditModalLifecycle: self.editModalLifecycle,
                              actionSender: self.actionSender)
    }
}
