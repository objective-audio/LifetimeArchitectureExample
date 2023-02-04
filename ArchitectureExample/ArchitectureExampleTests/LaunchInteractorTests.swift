//
//  LaunchInteractorTests.swift
//

import XCTest
@testable import ArchitectureExample

private class SceneLifecycleStub: SceneLifecycleForLaunchInteractor {
    var indexHandler: (SceneLifetimeId) -> Int? = { _ in nil }

    func index(of id: SceneLifetimeId) -> Int? {
        self.indexHandler(id)
    }
}

private class RootLifecycleStub: RootLifecycleForLaunchInteractor {
    var switchToLoginHandler: () -> Void = {}
    var switchToAccountHandler: (Account) -> Void = { _ in }

    var isLaunch: Bool = true

    func switchToLogin() {
        self.switchToLoginHandler()
    }

    func switchToAccount(account: Account) {
        self.switchToAccountHandler(account)
    }
}

private class RepositoryStub: AccountRepositoryForLaunchInteractor {
    var accounts: [Account] = []
}

private enum Called: Equatable {
    case switchToLogin
    case switchToAccount(Account)
    case index(SceneLifetimeId)
}

@MainActor
class LaunchInteractorTests: XCTestCase {
    private var sceneLifetimeId: SceneLifetimeId!
    private var sceneLifecycle: SceneLifecycleStub!
    private var rootLifecycle: RootLifecycleStub!
    private var repository: RepositoryStub!
    private var interactor: LaunchInteractor!

    @MainActor
    override func setUpWithError() throws {
        self.sceneLifetimeId = .init(instanceId: .init())
        self.sceneLifecycle = .init()
        self.rootLifecycle = .init()
        self.repository = .init()
        self.interactor = LaunchInteractor(sceneLifetimeId: self.sceneLifetimeId,
                                           sceneLifecycle: self.sceneLifecycle,
                                           rootLifecycle: self.rootLifecycle,
                                           accountRepository: self.repository)

        self.rootLifecycle.isLaunch = true
    }

    @MainActor
    override func tearDownWithError() throws {
        self.sceneLifetimeId = nil
        self.sceneLifecycle = nil
        self.rootLifecycle = nil
        self.repository = nil
    }

    func testLaunch_sceneはあるがaccountがなくてLoginに遷移() {
        var called: [Called] = []

        self.repository.accounts = []

        self.rootLifecycle.switchToLoginHandler = {
            called.append(.switchToLogin)
        }

        self.rootLifecycle.switchToAccountHandler = {
            called.append(.switchToAccount($0))
        }

        self.sceneLifecycle.indexHandler = {
            called.append(.index($0))
            return 0
        }

        XCTAssertEqual(called.count, 0)

        self.interactor.launch()

        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0], .index(self.sceneLifetimeId))
        XCTAssertEqual(called[1], .switchToLogin)
    }

    func testLaunch_accountはあるがsceneがなくてLoginに遷移() {
        var called: [Called] = []

        self.repository.accounts = [.init(id: 123, name: "test-name-123")]

        self.rootLifecycle.switchToLoginHandler = {
            called.append(.switchToLogin)
        }

        self.rootLifecycle.switchToAccountHandler = {
            called.append(.switchToAccount($0))
        }

        self.sceneLifecycle.indexHandler = {
            called.append(.index($0))
            return nil
        }

        XCTAssertEqual(called.count, 0)

        self.interactor.launch()

        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0], .index(self.sceneLifetimeId))
        XCTAssertEqual(called[1], .switchToLogin)
    }

    func testLaunch_sceneとaccountがありAccountに遷移() {
        var called: [Called] = []

        self.repository.accounts = [.init(id: 123, name: "test-name-123"), .init(id: 456, name: "test-name-456")]

        self.rootLifecycle.switchToLoginHandler = {
            called.append(.switchToLogin)
        }

        self.rootLifecycle.switchToAccountHandler = {
            called.append(.switchToAccount($0))
        }

        self.sceneLifecycle.indexHandler = {
            called.append(.index($0))
            return 1
        }

        XCTAssertEqual(called.count, 0)

        self.interactor.launch()

        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0], .index(self.sceneLifetimeId))
        XCTAssertEqual(called[1], .switchToAccount(.init(id: 456, name: "test-name-456")))
    }

    func testLaunch_起動処理ができる状態でなければ処理されない() {
        var called: [Called] = []

        self.rootLifecycle.isLaunch = false

        self.repository.accounts = []

        self.rootLifecycle.switchToLoginHandler = {
            called.append(.switchToLogin)
        }

        self.rootLifecycle.switchToAccountHandler = {
            called.append(.switchToAccount($0))
        }

        self.sceneLifecycle.indexHandler = {
            called.append(.index($0))
            return 0
        }

        self.interactor.launch()

        XCTAssertEqual(called.count, 0)
    }
}
