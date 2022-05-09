//
//  ModalSuspendingTests.swift
//

import XCTest
import Combine
@testable import ArchitectureExample

private enum Source {
    case one
    case two
}

private enum Modal: ModalConvertible {
    case first
    case second

    init?(_ source: Source?) {
        switch source {
        case .one:
            self = .first
        case .two:
            self = .second
        case .none:
            return nil
        }
    }
}

class ModalSuspendingTests: XCTestCase {
    private var input: CurrentValueSubject<Source?, Never>!
    private var isSuspended: CurrentValueSubject<Bool, Never>!

    override func setUpWithError() throws {
        self.input = .init(nil)
        self.isSuspended = .init(false)
    }

    override func tearDownWithError() throws {
        self.input = nil
        self.isSuspended = nil
    }

    func test_入力された値をブロックする() {
        var called: [Modal?] = []

        let canceller = modalSuspending(input: self.input,
                                        isSuspended: self.isSuspended,
                                        outputType: Modal.self)
        .removeDuplicates()
        .sink { called.append($0) }

        XCTContext.runActivity(named: "初期値はnil") { _ in
            XCTAssertEqual(called.count, 1)
            XCTAssertNil(called[0])
        }

        XCTContext.runActivity(named: "inputをセットしてそのまま反映される") { _ in
            self.input.value = .one

            XCTAssertEqual(called.count, 2)
            XCTAssertEqual(called[1], .first)
        }

        XCTContext.runActivity(named: "ブロックしてinputをセットしても反映されない") { _ in
            self.isSuspended.value = true
            self.input.value = nil
            self.input.value = .two

            XCTAssertEqual(called.count, 2)
        }

        XCTContext.runActivity(named: "ブロックを外して保留されていた値が反映される") { _ in
            self.isSuspended.value = false

            XCTAssertEqual(called.count, 3)
            XCTAssertEqual(called[2], .second)
        }

        XCTContext.runActivity(named: "inputをセットしてそのまま反映される") { _ in
            self.input.value = nil

            XCTAssertEqual(called.count, 4)
            XCTAssertNil(called[3])
        }

        canceller.cancel()
    }
}
