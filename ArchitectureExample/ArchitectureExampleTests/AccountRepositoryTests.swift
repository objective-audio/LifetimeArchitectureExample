//
//  AccountRepositoryTests.swift
//

import XCTest
@testable import ArchitectureExample

class AccountRepositoryTests: XCTestCase {
    private let userDefaultsSuiteName = "RepositoryTests"
    private var userDefaults: UserDefaults!
    
    override func setUpWithError() throws {
        UserDefaults().removePersistentDomain(forName: self.userDefaultsSuiteName)
        
        self.userDefaults = try XCTUnwrap(UserDefaults(suiteName: self.userDefaultsSuiteName))
    }

    override func tearDownWithError() throws {
        UserDefaults().removePersistentDomain(forName: self.userDefaultsSuiteName)
    }
    
    func testAppendAndRemoveAccounts() {
        let repository = AccountRepository(userDefaults: self.userDefaults)
        
        XCTAssertEqual(repository.accounts.count, 0)
        
        XCTContext.runActivity(named: "accountを追加して保存される") { _ in
            repository.append(account: .init(id: 123, name: "test-name-123"))
            
            XCTAssertEqual(repository.accounts.count, 1)
            XCTAssertEqual(repository.accounts[0], .init(id: 123, name: "test-name-123"))
            
            XCTAssertEqual(self.userDefaults.accounts as NSArray,
                           [["id": 123, "name": "test-name-123"]] as NSArray)
        }
        
        XCTContext.runActivity(named: "存在しているaccountが取得できる") { _ in
            XCTAssertEqual(repository.account(forId: 123), .init(id: 123, name: "test-name-123"))
            XCTAssertNil(repository.account(forId: 456))
        }
        
        XCTContext.runActivity(named: "accountを追加して2つ目の要素に保存される") { _ in
            repository.append(account: .init(id: 456, name: "test-name-456"))
            
            XCTAssertEqual(repository.accounts.count, 2)
            XCTAssertEqual(repository.accounts[0], .init(id: 123, name: "test-name-123"))
            XCTAssertEqual(repository.accounts[1], .init(id: 456, name: "test-name-456"))
            
            XCTAssertEqual(self.userDefaults.accounts as NSArray,
                           [["id": 123, "name": "test-name-123"],
                            ["id": 456, "name": "test-name-456"]] as NSArray)
        }
        
        XCTContext.runActivity(named: "保存されていないIdを指定して何もされない") { _ in
            repository.remove(accountId: 0)
            
            XCTAssertEqual(repository.accounts.count, 2)
        }
        
        XCTContext.runActivity(named: "保存されているIdを指定して削除される") { _ in
            repository.remove(accountId: 123)
            
            XCTAssertEqual(repository.accounts.count, 1)
            XCTAssertEqual(repository.accounts[0], .init(id: 456, name: "test-name-456"))
            
            XCTAssertEqual(self.userDefaults.accounts as NSArray,
                           [["id": 456, "name": "test-name-456"]] as NSArray)
        }
        
        XCTContext.runActivity(named: "残っているIdを指定して全て削除される") { _ in
            repository.remove(accountId: 456)
            
            XCTAssertEqual(repository.accounts.count, 0)
            
            XCTAssertEqual(self.userDefaults.accounts.count, 0)
        }
    }
    
    func testUpdateAccount() {
        let repository = AccountRepository(userDefaults: self.userDefaults)
        
        
        
        XCTContext.runActivity(named: "渡したaccountが存在しなければ何もしない") { _ in
            let account = Account(id: 123, name: "test-name-123")
            repository.update(account: account)
            
            XCTAssertEqual(repository.accounts.count, 0)
            XCTAssertEqual(self.userDefaults.accounts.count, 0)
        }
        
        XCTContext.runActivity(named: "") { _ in
            let original = Account(id: 123, name: "test-name-123")
            repository.append(account: original)
            
            XCTAssertEqual(repository.accounts.count, 1)
            XCTAssertEqual(repository.accounts[0], original)
            
            let updating = Account(id: 123, name: "test-name-123-updating")
            repository.update(account: updating)
            
            XCTAssertEqual(repository.accounts.count, 1)
            XCTAssertEqual(repository.accounts[0], updating)
        }
    }
}
