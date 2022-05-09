//
//  AccountEditInteractorTests.swift
//

import XCTest
@testable import ArchitectureExample

private class AccountInteractorStub: AccountInteractorForAccountEdit {
    var name: String = ""
}

private class RootModalRouterStub: RootModalLevelRouterForAccountEdit {
    var hideHandler: (AccountLevelId) -> Void = { _ in }
    
    func hideAccountEdit(accountLevelId: AccountLevelId) {
        hideHandler(accountLevelId)
    }
}

private class AccountEditModalRouterStub: AccountEditModalLevelRouterForAccountEdit {
    var showHandler: (AccountEditAlertContent) -> Void = { _ in }
    
    func showAlert(content: AccountEditAlertContent) {
        showHandler(content)
    }
}

@MainActor
class AccountEditInteractorTests: XCTestCase {
    private var accountLevelId: AccountLevelId!
    private var accountInteractor: AccountInteractorStub!
    private var rootRouter: RootModalRouterStub!
    private var editRouter: AccountEditModalRouterStub!
    
    @MainActor
    override func setUpWithError() throws {
        let sceneLevelId = SceneLevelId(instanceId: .init())
        self.accountLevelId = AccountLevelId(sceneLevelId: sceneLevelId,
                                             accountId: 123)
        
        self.accountInteractor = .init()
        self.rootRouter = .init()
        self.editRouter = .init()
    }

    @MainActor
    override func tearDownWithError() throws {
        self.accountLevelId = nil
        self.accountInteractor = nil
        self.rootRouter = nil
        self.editRouter = nil
    }
    
    func testEditAndSave() {
        self.accountInteractor.name = "original"
        
        var called: [AccountLevelId] = []
        
        self.rootRouter.hideHandler = { called.append($0) }
        
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
            XCTAssertEqual(self.accountInteractor.name, "original")
        }
        
        XCTContext.runActivity(named: "nameを戻したら保存できない") { _ in
            interactor.name = "original"
            
            XCTAssertFalse(interactor.isEdited)
        }
        
        XCTContext.runActivity(named: "nameを変更し保存して画面を閉じる") { _ in
            interactor.name = "test-name-234"
            
            XCTAssertTrue(interactor.isEdited)
            XCTAssertEqual(self.accountInteractor.name, "original")
            XCTAssertEqual(called.count, 0)
            
            interactor.save()
            
            XCTAssertEqual(self.accountInteractor.name, "test-name-234")
            XCTAssertEqual(called.count, 1)
            XCTAssertEqual(called[0], self.accountLevelId)
        }
    }
}

private extension AccountEditInteractorTests {
    func makeInteractor() -> AccountEditInteractor {
        AccountEditInteractor(accountLevelId: self.accountLevelId,
                              accountInteractor: self.accountInteractor,
                              rootModalRouter: self.rootRouter,
                              accountEditModalRouter: self.editRouter)
    }
}
