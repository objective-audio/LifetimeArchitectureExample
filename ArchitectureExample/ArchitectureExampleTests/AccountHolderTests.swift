//
//  AccountHolderTests.swift
//

import XCTest
@testable import ArchitectureExample

private class RepositoryStub: AccountHolder.Repository {
    var accounts: [Int: Account] = [:]

    func account(forId id: Int) -> Account? {
        self.accounts[id]
    }

    func update(account: Account) {
        self.accounts[account.id] = account
    }
}

@MainActor
class AccountHolderTests: XCTestCase {
    private var repository: RepositoryStub!

    @MainActor
    override func setUpWithError() throws {
        self.repository = .init()
    }

    @MainActor
    override func tearDownWithError() throws {
        self.repository = nil
    }

    func testInit() {
        self.repository.accounts = [123: .init(id: 123,
                                               name: "test-name-123")]

        let holder = AccountHolder(id: 123,
                                   accountRepository: self.repository)

        XCTAssertEqual(holder.id, 123)
        XCTAssertEqual(holder.name, "test-name-123")
    }

    func testNamePublisher() {
        let holder = AccountHolder(id: 123,
                                   accountRepository: self.repository)

        var called: [String] = []

        let canceller = holder.$name.sink {
            called.append($0)
        }

        XCTAssertEqual(called.count, 1)
        XCTAssertEqual(called[0], "")

        holder.name = "test-name-abc"

        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[1], "test-name-abc")

        canceller.cancel()
    }

    func testSave() {
        self.repository.accounts = [:]

        let holder = AccountHolder(id: 123,
                                   accountRepository: self.repository)

        XCTAssertNil(self.repository.accounts[123])

        holder.name = "test-name-123"

        XCTAssertEqual(self.repository.accounts[123], Account(id: 123, name: "test-name-123"))

        holder.name = "test-name-1234"

        XCTAssertEqual(self.repository.accounts[123], Account(id: 123, name: "test-name-1234"))
    }
}
