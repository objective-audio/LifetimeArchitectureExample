//
//  RootModalLevelRouterTests.swift
//

import XCTest
@testable import ArchitectureExample

@MainActor
class RootModalLevelRouterTests: XCTestCase {
    private var sceneLevelId: SceneLevelId!
    
    @MainActor
    override func setUpWithError() throws {
        self.sceneLevelId = .init(instanceId: .init())
    }

    @MainActor
    override func tearDownWithError() throws {
        self.sceneLevelId = nil
    }
    
    func testShowAndHideAlert() {
        let router = RootModalLevelRouter<EmptyLevelAccessor>(sceneLevelId: self.sceneLevelId)
        
        var called: [RootModalSubLevel?] = []
        
        let canceller = router.$current.sink { level in
            called.append(level)
        }
        
        XCTAssertNil(router.current)
        XCTAssertEqual(called.count, 1)
        XCTAssertNil(called[0])
        
        XCTContext.runActivity(named: "currentがnilなのでhideを呼んでも何もしない") { _ in
            router.hideAlert(id: .loginFailed(.other))
            
            XCTAssertEqual(called.count, 1)
        }
        
        XCTContext.runActivity(named: "currentがnilでshowを呼んだらcurrentが更新される") { _ in
            router.showAlert(content: .loginFailed(.other))
            
            guard case .alert(let level) = router.current,
                  level.content == .loginFailed(.other) else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(called.count, 2)
            
            guard case .alert(let level) = called[1],
                  level.content == .loginFailed(.other) else {
                XCTFail()
                return
            }
        }
        
        XCTContext.runActivity(named: "currentがあるときにshowを呼んでも何もしない") { _ in
            router.showAlert(content: .loginFailed(.other))
            
            XCTAssertEqual(called.count, 2)
        }
        
        XCTContext.runActivity(named: "showされているalertと違うものをhideしようとしても何もしない") { _ in
            router.hideAlert(id: .loginFailed(.cancelled))
            
            XCTAssertEqual(called.count, 2)
        }
        
        XCTContext.runActivity(named: "showされているalertをhideしたらcurrentがnilになる") { _ in
            router.hideAlert(id: .loginFailed(.other))
            
            XCTAssertNil(router.current)
            XCTAssertEqual(called.count, 3)
            XCTAssertNil(called[2])
        }
        
        canceller.cancel()
    }
    
    func testShowAndHideAccountEdit() {
        let accountLevelId = AccountLevelId(sceneLevelId: self.sceneLevelId,
                                            accountId: 123)
        
        let router = RootModalLevelRouter<EmptyLevelAccessor>(sceneLevelId: self.sceneLevelId)
        
        var called: [RootModalSubLevel?] = []
        
        let canceller = router.$current.sink { level in
            called.append(level)
        }
        
        XCTAssertNil(router.current)
        XCTAssertEqual(called.count, 1)
        XCTAssertNil(called[0])
        
        XCTContext.runActivity(named: "currentがnilなのでhideを呼んでも何もしない") { _ in
            router.hideAccountEdit(accountLevelId: accountLevelId)
            
            XCTAssertEqual(called.count, 1)
        }
        
        XCTContext.runActivity(named: "currentがnilでshowを呼んだらcurrentが更新される") { _ in
            router.showAccountEdit(accountLevelId: accountLevelId)
            
            guard case .accountEdit(let level) = router.current,
                  level.interactor.accountLevelId == accountLevelId else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(called.count, 2)
            
            guard case .accountEdit(let level) = called[1],
                  level.interactor.accountLevelId == accountLevelId else {
                XCTFail()
                return
            }
        }
        
        XCTContext.runActivity(named: "currentとがあるときにshowを呼んでも何もしない") { _ in
            router.showAccountEdit(accountLevelId: accountLevelId)
            
            XCTAssertEqual(called.count, 2)
        }
        
        XCTContext.runActivity(named: "showされているものと違うidでhideを呼んでも何もしない") { _ in
            let otherAccountLevelId = AccountLevelId(sceneLevelId: self.sceneLevelId, accountId: 234)
            router.hideAccountEdit(accountLevelId: otherAccountLevelId)
            
            XCTAssertEqual(called.count, 2)
        }
        
        XCTContext.runActivity(named: "showされているものをhideしたらcurrentがnilになる") { _ in
            router.hideAccountEdit(accountLevelId: accountLevelId)
            
            XCTAssertNil(router.current)
            XCTAssertEqual(called.count, 3)
            XCTAssertNil(called[2])
        }
        
        canceller.cancel()
    }
}
