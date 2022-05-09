//
//  LoginPresenterTests.swift
//

import XCTest
import Combine
@testable import ArchitectureExample

private class InteractorStub: LoginPresenter.Interactor {
    var accountId: String = ""
    var loginHandler: () -> Void = {}
    var cancelHandler: () -> Void = {}

    @CurrentValue var isValid: Bool = false
    @CurrentValue var isConnecting: Bool = false
    @CurrentValue var canOperate: Bool = true

    var isValidPublisher: AnyPublisher<Bool, Never> {
        self.$isValid.eraseToAnyPublisher()
    }

    var isConnectingPublisher: AnyPublisher<Bool, Never> {
        self.$isConnecting.eraseToAnyPublisher()
    }

    var canOperatePublisher: AnyPublisher<Bool, Never> {
        self.$canOperate.eraseToAnyPublisher()
    }

    func login() {
        self.loginHandler()
    }

    func cancel() {
        self.cancelHandler()
    }
}

@MainActor
class LoginPresenterTests: XCTestCase {
    private var interactor: InteractorStub!

    @MainActor
    override func setUpWithError() throws {
        self.interactor = .init()
    }

    @MainActor
    override func tearDownWithError() throws {
        self.interactor = nil
    }

    func testAccountId() {
        self.interactor.accountId = "123"

        let presenter = LoginPresenter(interactor: self.interactor)

        XCTContext.runActivity(named: "初期化時にinteractorの値が反映されている") { _ in
            XCTAssertEqual(presenter.accountId, "123")
        }

        XCTContext.runActivity(named: "セットして更新される") { _ in
            presenter.accountId = "1234"

            XCTAssertEqual(self.interactor.accountId, "1234")
        }
    }

    func testProperties() {
        let presenter = LoginPresenter(interactor: self.interactor)

        XCTContext.runActivity(named: "有効でなく通信中でなく操作可能") { _ in
            self.interactor.isValid = false
            self.interactor.isConnecting = false
            self.interactor.canOperate = true

            XCTAssertFalse(presenter.isTextFieldDisabled)
            XCTAssertFalse(presenter.isActivityIndicatorEnabled)
            XCTAssertTrue(presenter.isLoginButtonDisabled)
        }

        XCTContext.runActivity(named: "有効で通信中でなく操作可能") { _ in
            self.interactor.isValid = true
            self.interactor.isConnecting = false
            self.interactor.canOperate = true

            XCTAssertFalse(presenter.isTextFieldDisabled)
            XCTAssertFalse(presenter.isActivityIndicatorEnabled)
            XCTAssertFalse(presenter.isLoginButtonDisabled)
        }

        XCTContext.runActivity(named: "有効で通信中でなく操作不可能") { _ in
            self.interactor.isValid = true
            self.interactor.isConnecting = false
            self.interactor.canOperate = false

            XCTAssertTrue(presenter.isTextFieldDisabled)
            XCTAssertFalse(presenter.isActivityIndicatorEnabled)
            XCTAssertTrue(presenter.isLoginButtonDisabled)
        }

        XCTContext.runActivity(named: "有効で通信中で操作可能") { _ in
            self.interactor.isValid = true
            self.interactor.isConnecting = true
            self.interactor.canOperate = true

            XCTAssertTrue(presenter.isTextFieldDisabled)
            XCTAssertTrue(presenter.isActivityIndicatorEnabled)
            XCTAssertTrue(presenter.isLoginButtonDisabled)
        }
    }

    func testLogin() {
        var called: Int = 0

        self.interactor.loginHandler = {
            called += 1
        }

        let presenter = LoginPresenter(interactor: self.interactor)

        XCTAssertEqual(called, 0)

        presenter.login()

        XCTAssertEqual(called, 1)
    }

    func testCancel() {
        var called: Int = 0

        self.interactor.cancelHandler = {
            called += 1
        }

        let presenter = LoginPresenter(interactor: self.interactor)

        XCTAssertEqual(called, 0)

        presenter.cancel()

        XCTAssertEqual(called, 1)
    }
}
