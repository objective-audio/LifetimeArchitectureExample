//
//  LoginInteractorTests.swift
//

import XCTest
import Combine
@testable import ArchitectureExample

private class RootLevelRouterStub: RootLevelRouterForLogin {
    @CurrentValue var isLogin: Bool = true
    
    var isLoginPublisher: AnyPublisher<Bool, Never> {
        self.$isLogin.eraseToAnyPublisher()
    }
    
    var switchToAccountHandler: (Account) -> Void = { _ in }
    
    func switchToAccount(account: Account) {
        self.switchToAccountHandler(account)
    }
}

private class RootLevelModalRouterStub: RootModalLevelRouterForLogin {
    var showAlertHandler: (RootAlertContent) -> Void = { _ in }
    
    func showAlert(content: RootAlertContent) {
        self.showAlertHandler(content)
    }
}

private class RepositoryStub: AccountRepositoryForLogin {
    var accounts: [Account] = []
    
    var appendAccountHandler: (Account?) -> Void = { _ in }
    
    func append(account: Account) {
        self.appendAccountHandler(account)
    }
}

private class NetworkStub: LoginNetworkForLogin {
    var getAccountHandler: (String) -> Void = { _ in }
    var continuationHandler: (CheckedContinuation<Result<Account, LoginNetworkError>, Never>) -> Void = { _ in }
    
    func getAccount(id: String) async -> Result<Account, LoginNetworkError> {
        self.getAccountHandler(id)
        
        return await withCheckedContinuation { continuation in
            self.continuationHandler(continuation)
        }
    }
}

private enum Called {
    case switchToAccount(Account)
    case alert(RootAlertContent)
    case setAccount(Account?)
    case networkGetAccount(id: String)
    case networkContinuation(CheckedContinuation<Result<Account, LoginNetworkError>, Never>)
}

@MainActor
class LoginInteractorTests: XCTestCase {
    private var rootRouter: RootLevelRouterStub!
    private var rootModalRouter: RootLevelModalRouterStub!
    private var repository: RepositoryStub!
    private var network: NetworkStub!
    
    @MainActor override func setUpWithError() throws {
        self.rootRouter = .init()
        self.rootModalRouter = .init()
        self.repository = .init()
        self.network = .init()
    }

    @MainActor override func tearDownWithError() throws {
        self.rootRouter = nil
        self.rootModalRouter = nil
        self.repository = nil
        self.network = nil
    }
    
    func testIsValid() {
        let interactor = makeInteractor()
        
        XCTContext.runActivity(named: "accountIdが空ならfalse") { _ in
            interactor.accountId = ""
            
            XCTAssertFalse(interactor.isValid)
        }
        
        XCTContext.runActivity(named: "accountIdが空でなければtrue") { _ in
            interactor.accountId = "1"
            
            XCTAssertTrue(interactor.isValid)
            
            interactor.accountId = "a"
            
            XCTAssertTrue(interactor.isValid)
        }
    }
    
    func testIsValidPublisher() {
        let interactor = makeInteractor()
        
        var called: [Bool] = []
        
        let canceller = interactor.isValidPublisher.sink { isValid in
            called.append(isValid)
        }
        
        XCTContext.runActivity(named: "最初はfalse") { _ in
            XCTAssertEqual(called.count, 1)
            XCTAssertFalse(called[0])
        }
        
        XCTContext.runActivity(named: "accountIdが変更されisValidがtrueになって通知される") { _ in
            interactor.accountId = "1"
            
            XCTAssertEqual(called.count, 2)
            XCTAssertTrue(called[1])
        }
        
        XCTContext.runActivity(named: "accountIdが変更されてもisValidに変化がなければ通知されない") { _ in
            interactor.accountId = "12"
            
            XCTAssertEqual(called.count, 2)
        }
        
        XCTContext.runActivity(named: "isValidが変わったら通知される") { _ in
            interactor.accountId = ""
            
            XCTAssertEqual(called.count, 3)
            XCTAssertFalse(called[2])
        }
        
        canceller.cancel()
    }
    
    func testIsConnectingPublisher() {
        let networkExpectation = self.expectation(description: "network")
        let routeExpectation = self.expectation(description: "route")
        
        var handledContinuation: CheckedContinuation<Result<Account, LoginNetworkError>, Never>?
        
        self.network.continuationHandler = { continuation in
            handledContinuation = continuation
            networkExpectation.fulfill()
        }
        
        self.rootRouter.switchToAccountHandler = { account in
            routeExpectation.fulfill()
        }
        
        let interactor = makeInteractor()
        
        var called: [Bool] = []
        
        let canceller = interactor.isConnectingPublisher.sink { isConnecting in
            called.append(isConnecting)
        }
        
        XCTContext.runActivity(named: "最初はfalse") { _ in
            XCTAssertEqual(called.count, 1)
            XCTAssertFalse(called[0])
        }
        
        XCTContext.runActivity(named: "ログインを呼んで通信中はtrue") { _ in
            interactor.accountId = "123"
            interactor.login()
            
            self.wait(for: [networkExpectation], timeout: 10.0)
            
            XCTAssertEqual(called.count, 2)
            XCTAssertTrue(called[1])
        }
        
        XCTContext.runActivity(named: "通信が終わったらfalse") { _ in
            handledContinuation?.resume(returning: .success(.init(id: 123, name: "test-name-123")))
            
            self.wait(for: [routeExpectation], timeout: 10.0)
            
            XCTAssertEqual(called.count, 3)
            XCTAssertFalse(called[2])
        }
        
        canceller.cancel()
    }
    
    func testCanOperatePublisher() {
        let interactor = makeInteractor()
        
        self.rootRouter.isLogin = true
        
        var called: [Bool] = []
        
        let canceller = interactor.canOperatePublisher.sink { isValid in
            called.append(isValid)
        }
        
        XCTContext.runActivity(named: "isLoginがtrueならtrue") { _ in
            XCTAssertEqual(called.count, 1)
            XCTAssertTrue(called[0])
        }
        
        XCTContext.runActivity(named: "isLoginがfalseならfalse") { _ in
            self.rootRouter.isLogin = false
            
            XCTAssertEqual(called.count, 2)
            XCTAssertFalse(called[1])
        }
        
        canceller.cancel()
    }
    
    func testLogin_accountIdが無効で呼んでも無視() {
        let interactor = makeInteractor()
        
        XCTAssertFalse(interactor.isValid)
        
        interactor.login()
        
        XCTAssertFalse(interactor.isConnecting)
    }
    
    func testLogin_通信が成功してAccountを返す() {
        var called: [Called] = []
        
        let networkExpectation = self.expectation(description: "network")
        let routeExpectation = self.expectation(description: "route")
        
        self.rootRouter.switchToAccountHandler = { account in
            called.append(.switchToAccount(account))
            routeExpectation.fulfill()
        }
        
        self.rootModalRouter.showAlertHandler = { content in
            called.append(.alert(content))
        }
        
        self.repository.appendAccountHandler = { account in
            called.append(.setAccount(account))
        }
        
        self.repository.accounts = []
        
        self.network.getAccountHandler = { accountId in
            called.append(.networkGetAccount(id: accountId))
        }
        
        self.network.continuationHandler = { continuation in
            called.append(.networkContinuation(continuation))
            networkExpectation.fulfill()
        }
        
        let interactor = makeInteractor()
        
        interactor.accountId = "123"
        
        XCTAssertTrue(interactor.isValid)
        
        interactor.login()
        
        XCTAssertTrue(interactor.isConnecting)
        
        self.wait(for: [networkExpectation], timeout: 10.0)
        
        XCTAssertEqual(called.count, 2)
        
        guard case .networkGetAccount(let accountId) = called[0],
              accountId == "123" else {
            XCTFail()
            return
        }
        
        guard case .networkContinuation(let continuation) = called[1] else {
            XCTFail()
            return
        }
        
        continuation.resume(returning: .success(.init(id: 123, name: "test-name-123")))
        
        self.wait(for: [routeExpectation], timeout: 10.0)
        
        XCTAssertEqual(called.count, 4)
        
        guard case .setAccount(let setAccount) = called[2],
              case .switchToAccount(let switchedAccount) = called[3] else {
            XCTFail()
            return
        }
        
        let expectedAccount = Account(id: 123, name: "test-name-123")
        
        XCTAssertEqual(setAccount, expectedAccount)
        XCTAssertEqual(switchedAccount, expectedAccount)
        XCTAssertFalse(interactor.isConnecting)
    }
    
    func testLogin_通信が失敗してアラートを表示する() {
        var called: [Called] = []
        
        let networkExpectation = self.expectation(description: "network")
        let alertExpectation = self.expectation(description: "alert")
        
        self.rootRouter.switchToAccountHandler = { account in
            called.append(.switchToAccount(account))
        }
        
        self.rootModalRouter.showAlertHandler = { content in
            called.append(.alert(content))
            alertExpectation.fulfill()
        }
        
        self.repository.appendAccountHandler = { account in
            called.append(.setAccount(account))
        }
        
        self.repository.accounts = []
        
        self.network.getAccountHandler = { accountId in
            called.append(.networkGetAccount(id: accountId))
        }
        
        self.network.continuationHandler = { continuation in
            called.append(.networkContinuation(continuation))
            networkExpectation.fulfill()
        }
        
        let interactor = makeInteractor()
        
        interactor.accountId = "234"
        
        XCTAssertTrue(interactor.isValid)
        
        interactor.login()
        
        XCTAssertTrue(interactor.isConnecting)
        
        self.wait(for: [networkExpectation], timeout: 10.0)
        
        XCTAssertEqual(called.count, 2)
        
        guard case .networkGetAccount(let accountId) = called[0],
              accountId == "234" else {
            XCTFail()
            return
        }
        
        guard case .networkContinuation(let continuation) = called[1] else {
            XCTFail()
            return
        }
        
        continuation.resume(returning: .failure(.invalidAccountID))
        
        self.wait(for: [alertExpectation], timeout: 10.0)
        
        XCTAssertEqual(called.count, 3)
        
        guard case .alert(let alertContent) = called[2] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(alertContent, .loginFailed(.invalidAccountID))
        XCTAssertFalse(interactor.isConnecting)
    }
    
    func testLogin_通信が終わる前にキャンセルしてアラートを表示() {
        var called: [Called] = []
        
        let networkExpectation = self.expectation(description: "network")
        let alertExpectation = self.expectation(description: "alert")
        
        self.rootRouter.switchToAccountHandler = { account in
            called.append(.switchToAccount(account))
        }
        
        self.rootModalRouter.showAlertHandler = { content in
            called.append(.alert(content))
            alertExpectation.fulfill()
        }
        
        self.repository.appendAccountHandler = { account in
            called.append(.setAccount(account))
        }
        
        self.repository.accounts = []
        
        self.network.getAccountHandler = { accountId in
            called.append(.networkGetAccount(id: accountId))
        }
        
        self.network.continuationHandler = { continuation in
            called.append(.networkContinuation(continuation))
            networkExpectation.fulfill()
        }
        
        let interactor = makeInteractor()
        
        interactor.accountId = "345"
        
        XCTAssertTrue(interactor.isValid)
        
        interactor.login()
        
        XCTAssertTrue(interactor.isConnecting)
        
        self.wait(for: [networkExpectation], timeout: 10.0)
        
        XCTAssertEqual(called.count, 2)
        
        guard case .networkGetAccount(let accountId) = called[0],
              accountId == "345" else {
            XCTFail()
            return
        }
        
        guard case .networkContinuation(let continuation) = called[1] else {
            XCTFail()
            return
        }
        
        interactor.cancel()
        
        continuation.resume(returning: .success(.init(id: 345, name: "test-name-345")))
        
        self.wait(for: [alertExpectation], timeout: 10.0)
        
        XCTAssertEqual(called.count, 3)
        
        guard case .alert(let alertContent) = called[2] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(alertContent, .loginFailed(.cancelled))
        XCTAssertFalse(interactor.isConnecting)
    }
    
    func testLogin_すでにログイン済みのアカウントでアラートを表示() {
        var called: [Called] = []
        
        let networkExpectation = self.expectation(description: "network")
        let alertExpectation = self.expectation(description: "alert")
        
        self.rootRouter.switchToAccountHandler = { account in
            called.append(.switchToAccount(account))
        }
        
        self.rootModalRouter.showAlertHandler = { content in
            called.append(.alert(content))
            alertExpectation.fulfill()
        }
        
        self.repository.appendAccountHandler = { account in
            called.append(.setAccount(account))
        }
        
        self.repository.accounts = [.init(id: 456, name: "test-name-456")]
        
        self.network.getAccountHandler = { accountId in
            called.append(.networkGetAccount(id: accountId))
        }
        
        self.network.continuationHandler = { continuation in
            called.append(.networkContinuation(continuation))
            networkExpectation.fulfill()
        }
        
        let interactor = makeInteractor()
        
        interactor.accountId = "456"
        
        XCTAssertTrue(interactor.isValid)
        
        interactor.login()
        
        XCTAssertTrue(interactor.isConnecting)
        
        self.wait(for: [networkExpectation], timeout: 10.0)
        
        XCTAssertEqual(called.count, 2)
        
        guard case .networkGetAccount(let accountId) = called[0],
              accountId == "456" else {
            XCTFail()
            return
        }
        
        guard case .networkContinuation(let continuation) = called[1] else {
            XCTFail()
            return
        }
        
        continuation.resume(returning: .success(.init(id: 456, name: "test-name-456")))
        
        self.wait(for: [alertExpectation], timeout: 10.0)
        
        XCTAssertEqual(called.count, 3)
        
        guard case .alert(let alertContent) = called[2] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(alertContent, .loginFailed(.accountDuplicated))
        XCTAssertFalse(interactor.isConnecting)
    }
}

private extension LoginInteractorTests {
    func makeInteractor() -> LoginInteractor {
        LoginInteractor(sceneLevelId: .init(instanceId: .init()),
                        rootLevelRouter: self.rootRouter,
                        rootModalLevelRouter: self.rootModalRouter,
                        accountRepository: self.repository,
                        network: self.network)
    }
}
