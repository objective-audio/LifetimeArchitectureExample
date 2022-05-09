//
//  LaunchInteractorTests.swift
//

import XCTest
@testable import ArchitectureExample

private class SceneLevelRouterStub: SceneLevelRouterForLaunch {
    var indexHandler: (SceneLevelId) -> Int? = { _ in nil }
    
    func index(of id: SceneLevelId) -> Int? {
        self.indexHandler(id)
    }
}

private class RootLevelRouterStub: RootLevelRouterForLaunch {
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

private class RepositoryStub: AccountRepositoryForLaunch {
    var accounts: [Account] = []
}

private enum Called: Equatable {
    case switchToLogin
    case switchToAccount(Account)
    case index(SceneLevelId)
}

@MainActor
class LaunchInteractorTests: XCTestCase {
    private var sceneLevelId: SceneLevelId!
    private var sceneLevelRouter: SceneLevelRouterStub!
    private var rootLevelRouter: RootLevelRouterStub!
    private var repository: RepositoryStub!
    private var interactor: LaunchInteractor!

    @MainActor
    override func setUpWithError() throws {
        self.sceneLevelId = .init(instanceId: .init())
        self.sceneLevelRouter = .init()
        self.rootLevelRouter = .init()
        self.repository = .init()
        self.interactor = LaunchInteractor(sceneLevelId: self.sceneLevelId,
                                 sceneLevelRouter: self.sceneLevelRouter,
                                 rootLevelRouter: self.rootLevelRouter,
                                 accountRepository: self.repository)
        
        self.rootLevelRouter.isLaunch = true
    }

    @MainActor
    override func tearDownWithError() throws {
        self.sceneLevelId = nil
        self.sceneLevelRouter = nil
        self.rootLevelRouter = nil
        self.repository = nil
    }

    func testLaunch_sceneはあるがaccountがなくてLoginに遷移() {
        var called: [Called] = []
        
        self.repository.accounts = []
        
        self.rootLevelRouter.switchToLoginHandler = {
            called.append(.switchToLogin)
        }
        
        self.rootLevelRouter.switchToAccountHandler = {
            called.append(.switchToAccount($0))
        }
        
        self.sceneLevelRouter.indexHandler = {
            called.append(.index($0))
            return 0
        }
        
        XCTAssertEqual(called.count, 0)
        
        self.interactor.launch()
        
        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0], .index(self.sceneLevelId))
        XCTAssertEqual(called[1], .switchToLogin)
    }
    
    func testLaunch_accountはあるがsceneがなくてLoginに遷移() {
        var called: [Called] = []
        
        self.repository.accounts = [.init(id: 123, name: "test-name-123")]
        
        self.rootLevelRouter.switchToLoginHandler = {
            called.append(.switchToLogin)
        }
        
        self.rootLevelRouter.switchToAccountHandler = {
            called.append(.switchToAccount($0))
        }
        
        self.sceneLevelRouter.indexHandler = {
            called.append(.index($0))
            return nil
        }
        
        XCTAssertEqual(called.count, 0)
        
        self.interactor.launch()
        
        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0], .index(self.sceneLevelId))
        XCTAssertEqual(called[1], .switchToLogin)
    }
    
    func testLaunch_sceneとaccountがありAccountに遷移() {
        var called: [Called] = []
        
        self.repository.accounts = [.init(id: 123, name: "test-name-123"), .init(id: 456, name: "test-name-456")]
        
        self.rootLevelRouter.switchToLoginHandler = {
            called.append(.switchToLogin)
        }
        
        self.rootLevelRouter.switchToAccountHandler = {
            called.append(.switchToAccount($0))
        }
        
        self.sceneLevelRouter.indexHandler = {
            called.append(.index($0))
            return 1
        }
        
        XCTAssertEqual(called.count, 0)
        
        self.interactor.launch()
        
        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0], .index(self.sceneLevelId))
        XCTAssertEqual(called[1], .switchToAccount(.init(id: 456, name: "test-name-456")))
    }
    
    func testLaunch_起動処理ができる状態でなければ処理されない() {
        var called: [Called] = []
        
        self.rootLevelRouter.isLaunch = false
        
        self.repository.accounts = []
        
        self.rootLevelRouter.switchToLoginHandler = {
            called.append(.switchToLogin)
        }
        
        self.rootLevelRouter.switchToAccountHandler = {
            called.append(.switchToAccount($0))
        }
        
        self.sceneLevelRouter.indexHandler = {
            called.append(.index($0))
            return 0
        }
        
        self.interactor.launch()
        
        XCTAssertEqual(called.count, 0)
    }
}
