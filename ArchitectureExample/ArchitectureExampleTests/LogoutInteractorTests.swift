//
//  LogoutInteractorTests.swift
//

import XCTest
@testable import ArchitectureExample

private class RepositoryStub: LogoutInteractor.AccountRepository {
    var removeHandler: (Int) -> Void = { _ in }

    func remove(accountId: Int) {
        self.removeHandler(accountId)
    }
}

private class RootLifecycleStub: LogoutInteractor.RootLifecycle {
    var switchToLoginHandler: () -> Void = {}

    func switchToLogin() {
        self.switchToLoginHandler()
    }
}

class LogoutInteractorTests: XCTestCase {
    private var repository: RepositoryStub!
    private var rootLifecycle: RootLifecycleStub!

    override func setUpWithError() throws {
        self.repository = .init()
        self.rootLifecycle = .init()
    }

    override func tearDownWithError() throws {
        self.repository = nil
        self.rootLifecycle = nil
    }

    @MainActor
    func testLogout() throws {
        enum Called: Equatable {
            case removeAccount(Int)
            case switchToLogin
        }

        var called: [Called] = []

        self.rootLifecycle.switchToLoginHandler = { called.append(.switchToLogin) }
        self.repository.removeHandler = { called.append(.removeAccount($0)) }

        let interactor = LogoutInteractor(accountId: 1,
                                          rootLifecycle: self.rootLifecycle,
                                          accountRepository: self.repository)

        XCTAssertTrue(called.isEmpty)

        interactor.logout()

        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0], .removeAccount(1))
        XCTAssertEqual(called[1], .switchToLogin)

        // 2回呼んでも無視される

        interactor.logout()

        XCTAssertEqual(called.count, 2)
    }
}
