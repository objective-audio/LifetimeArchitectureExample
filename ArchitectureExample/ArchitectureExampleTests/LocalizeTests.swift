//
//  LocalizeTests.swift
//

import XCTest
@testable import ArchitectureExample

class LocalizeTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test() {
        for localized in Localized.allCases {
            XCTAssertNotEqual(localized.value, localized.rawValue)
        }
    }
}
