//
//  UINavigationControllerUpdationTests.swift
//

import XCTest
@testable import ArchitectureExample

class UINavigationControllerUpdationTests: XCTestCase {
    typealias Updation<Element: Equatable> = UINavigationController.Updation<Element>

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testInit_正しい遷移() {
        XCTContext.runActivity(named: "newとoldが同じであればnil") { _ in
            XCTAssertNil(Updation<Int>(newElements: [],
                                       oldElements: []))
            XCTAssertNil(Updation<Int>(newElements: [1],
                                       oldElements: [1]))
            XCTAssertNil(Updation<Int>(newElements: [1, 2],
                                       oldElements: [1, 2]))
        }

        XCTContext.runActivity(named: "oldがなくnewがあれば全てset") { _ in
            XCTAssertEqual(Updation<Int>(newElements: [1],
                                         oldElements: []), .set(elements: [1]))
            XCTAssertEqual(Updation<Int>(newElements: [1, 2],
                                         oldElements: []), .set(elements: [1, 2]))
        }

        XCTContext.runActivity(named: "oldが有りnewが空であれば空のset") { _ in
            XCTAssertEqual(Updation<Int>(newElements: [],
                                         oldElements: [1]), .set(elements: []))
            XCTAssertEqual(Updation<Int>(newElements: [],
                                         oldElements: [1, 2]), .set(elements: []))
        }

        XCTContext.runActivity(named: "newがoldより少なく一致していればpop") { _ in
            XCTAssertEqual(Updation<Int>(newElements: [1],
                                         oldElements: [1, 2]), .pop(toIndex: 0))
            XCTAssertEqual(Updation<Int>(newElements: [1],
                                         oldElements: [1, 2, 3]), .pop(toIndex: 0))
            XCTAssertEqual(Updation<Int>(newElements: [1, 2],
                                         oldElements: [1, 2, 3]), .pop(toIndex: 1))
        }

        XCTContext.runActivity(named: "newがoldより1つ多く一致していればpush") { _ in
            XCTAssertEqual(Updation<Int>(newElements: [1, 2],
                                         oldElements: [1]), .push(element: 2))
            XCTAssertEqual(Updation<Int>(newElements: [1, 2, 3],
                                         oldElements: [1, 2]), .push(element: 3))
        }
    }

    func testInit_不整合で全て置き換え() {
        XCTContext.runActivity(named: "newがoldより2つ以上多い") { _ in
            XCTAssertEqual(Updation<Int>(newElements: [1, 2],
                                         oldElements: []), .set(elements: [1, 2]))
            XCTAssertEqual(Updation<Int>(newElements: [1, 2, 3],
                                         oldElements: []), .set(elements: [1, 2, 3]))
            XCTAssertEqual(Updation<Int>(newElements: [1, 2, 3],
                                         oldElements: [1]), .set(elements: [1, 2, 3]))
        }

        XCTContext.runActivity(named: "newとoldの数は同じだが一致しない") { _ in
            XCTAssertEqual(Updation<Int>(newElements: [1],
                                         oldElements: [2]), .set(elements: [1]))
            XCTAssertEqual(Updation<Int>(newElements: [1, 3],
                                         oldElements: [1, 2]), .set(elements: [1, 3]))
            XCTAssertEqual(Updation<Int>(newElements: [2, 1],
                                         oldElements: [3, 1]), .set(elements: [2, 1]))
            XCTAssertEqual(Updation<Int>(newElements: [1, 2, 3, 4],
                                         oldElements: [1, 2, 3, 5]), .set(elements: [1, 2, 3, 4]))
        }

        XCTContext.runActivity(named: "newがoldより少ないが一致しない") { _ in
            XCTAssertEqual(Updation<Int>(newElements: [2],
                                         oldElements: [1, 2]), .set(elements: [2]))
            XCTAssertEqual(Updation<Int>(newElements: [3],
                                         oldElements: [1, 2]), .set(elements: [3]))
            XCTAssertEqual(Updation<Int>(newElements: [4],
                                         oldElements: [1, 2, 3]), .set(elements: [4]))
            XCTAssertEqual(Updation<Int>(newElements: [1, 4],
                                         oldElements: [1, 2, 3]), .set(elements: [1, 4]))
        }

        XCTContext.runActivity(named: "newがoldより1つ多いが一致しない") { _ in
            XCTAssertEqual(Updation<Int>(newElements: [2, 3],
                                         oldElements: [1]), .set(elements: [2, 3]))
            XCTAssertEqual(Updation<Int>(newElements: [2, 1],
                                         oldElements: [1]), .set(elements: [2, 1]))
            XCTAssertEqual(Updation<Int>(newElements: [1, 2, 3, 4],
                                         oldElements: [1, 5, 3]), .set(elements: [1, 2, 3, 4]))
        }
    }
}
