//
//  ActionSenderTests.swift
//

import XCTest
@testable import ArchitectureExample

private class ReceiverStub: ActionReceivable {
    var receiveHandler: (Action) -> ActionContinuation = { _ in .continue }

    var receivableId: ActionId?

    func receive(_ action: Action) -> ActionContinuation {
        return self.receiveHandler(action)
    }
}

private class ProviderStub: ActionReceiverProvidable {
    var receivableId: ActionId?
    var receivers: [ActionReceivable] = []
    var subProviders: [ActionReceiverProvidable] = []
}

private enum Receiver {
    case root
    case child1
    case child2
    case grandChild
}

private struct Called {
    let receiver: Receiver
    let action: Action
}

@MainActor
class ActionSenderTests: XCTestCase {
    private var rootReceiver: ReceiverStub!
    private var childReceiver1: ReceiverStub!
    private var childReceiver2: ReceiverStub!
    private var grandChildReceiver: ReceiverStub!

    private var rootProvider: ProviderStub!
    private var childProvider1: ProviderStub!
    private var childProvider2: ProviderStub!
    private var grandChildProvider: ProviderStub!

    @MainActor
    override func setUpWithError() throws {
        self.rootReceiver = .init()
        self.childReceiver1 = .init()
        self.childReceiver2 = .init()
        self.grandChildReceiver = .init()

        self.rootProvider = .init()
        self.childProvider1 = .init()
        self.childProvider2 = .init()
        self.grandChildProvider = .init()

        self.rootProvider.receivers = [self.rootReceiver]
        self.rootProvider.subProviders = [self.childProvider1,
                                          self.childProvider2]

        self.childProvider1.receivers = [self.childReceiver1]
        self.childProvider1.subProviders = [self.grandChildProvider]
        self.childProvider2.receivers = [self.childReceiver2]

        self.grandChildProvider.receivers = [self.grandChildReceiver]
    }

    @MainActor
    override func tearDownWithError() throws {
        self.rootReceiver = nil
        self.childReceiver1 = nil
        self.childReceiver2 = nil
        self.grandChildReceiver = nil

        self.rootProvider = nil
        self.childProvider1 = nil
        self.childProvider2 = nil
        self.grandChildProvider = nil
    }

    func test_actionがnilでfallthroughを返して全て呼ばれる() {
        var called: [Called] = []

        // receivableIdを指定しているがactionがnilなので影響しない
        let receivableId = ActionId(sceneLifetimeId: .init(instanceId: .init()))
        self.rootReceiver.receivableId = receivableId
        self.childReceiver1.receivableId = receivableId
        self.childReceiver2.receivableId = receivableId
        self.grandChildReceiver.receivableId = receivableId

        self.rootReceiver.receiveHandler = { action in
            called.append(.init(receiver: .root, action: action))
            return .continue
        }

        self.childReceiver1.receiveHandler = { action in
            called.append(.init(receiver: .child1, action: action))
            return .continue
        }

        self.childReceiver2.receiveHandler = { action in
            called.append(.init(receiver: .child2, action: action))
            return .continue
        }

        self.grandChildReceiver.receiveHandler = { action in
            called.append(.init(receiver: .grandChild, action: action))
            return .continue
        }

        let sender = ActionSender(rootProvider: self.rootProvider)

        XCTAssertEqual(called.count, 0)

        sender.send(.init(kind: .logout, id: nil))

        XCTAssertEqual(called.count, 4)
        XCTAssertEqual(called[0].receiver, .grandChild)
        XCTAssertEqual(called[0].action.kind, .logout)
        XCTAssertNil(called[0].action.id)
        XCTAssertEqual(called[1].receiver, .child1)
        XCTAssertEqual(called[1].action.kind, .logout)
        XCTAssertNil(called[1].action.id)
        XCTAssertEqual(called[2].receiver, .child2)
        XCTAssertEqual(called[2].action.kind, .logout)
        XCTAssertNil(called[2].action.id)
        XCTAssertEqual(called[3].receiver, .root)
        XCTAssertEqual(called[3].action.kind, .logout)
        XCTAssertNil(called[3].action.id)
    }

    func test_actionがありproviderのreceivableIdが一致しないと子も含めて呼ばれない() {
        var called: [Called] = []

        self.childProvider1.receivableId = .init(sceneLifetimeId: .init(instanceId: .init()))

        self.rootReceiver.receiveHandler = { action in
            called.append(.init(receiver: .root, action: action))
            return .continue
        }

        self.childReceiver1.receiveHandler = { action in
            called.append(.init(receiver: .child1, action: action))
            return .continue
        }

        self.childReceiver2.receiveHandler = { action in
            called.append(.init(receiver: .child2, action: action))
            return .continue
        }

        self.grandChildReceiver.receiveHandler = { action in
            called.append(.init(receiver: .grandChild, action: action))
            return .continue
        }

        let actionId = ActionId(sceneLifetimeId: .init(instanceId: .init()))

        let sender = ActionSender(rootProvider: self.rootProvider)

        XCTAssertEqual(called.count, 0)

        sender.send(.init(kind: .logout, id: actionId))

        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0].receiver, .child2)
        XCTAssertEqual(called[0].action.kind, .logout)
        XCTAssertEqual(called[0].action.id, actionId)
        XCTAssertEqual(called[1].receiver, .root)
        XCTAssertEqual(called[1].action.kind, .logout)
        XCTAssertEqual(called[1].action.id, actionId)
    }

    func test_actionがありreceiverのreceivableIdが一致しないと呼ばれない() {
        var called: [Called] = []

        self.childReceiver1.receivableId = .init(sceneLifetimeId: .init(instanceId: .init()))

        self.rootReceiver.receiveHandler = { action in
            called.append(.init(receiver: .root, action: action))
            return .continue
        }

        self.childReceiver1.receiveHandler = { action in
            called.append(.init(receiver: .child1, action: action))
            return .continue
        }

        self.childReceiver2.receiveHandler = { action in
            called.append(.init(receiver: .child2, action: action))
            return .continue
        }

        self.grandChildReceiver.receiveHandler = { action in
            called.append(.init(receiver: .grandChild, action: action))
            return .continue
        }

        let actionId = ActionId(sceneLifetimeId: .init(instanceId: .init()))

        let sender = ActionSender(rootProvider: self.rootProvider)

        XCTAssertEqual(called.count, 0)

        sender.send(.init(kind: .logout, id: actionId))

        XCTAssertEqual(called.count, 3)
        XCTAssertEqual(called[0].receiver, .grandChild)
        XCTAssertEqual(called[0].action.kind, .logout)
        XCTAssertEqual(called[0].action.id, actionId)
        XCTAssertEqual(called[1].receiver, .child2)
        XCTAssertEqual(called[1].action.kind, .logout)
        XCTAssertEqual(called[1].action.id, actionId)
        XCTAssertEqual(called[2].receiver, .root)
        XCTAssertEqual(called[2].action.kind, .logout)
        XCTAssertEqual(called[2].action.id, actionId)
    }

    func test_receiveでbreakを返すとそれ以降は呼ばれない() {
        var called: [Called] = []

        // receivableIdを指定しているがactionがnilなので影響しない
        let receivableId = ActionId(sceneLifetimeId: .init(instanceId: .init()))
        self.rootReceiver.receivableId = receivableId
        self.childReceiver1.receivableId = receivableId
        self.childReceiver2.receivableId = receivableId
        self.grandChildReceiver.receivableId = receivableId

        self.rootReceiver.receiveHandler = { action in
            called.append(.init(receiver: .root, action: action))
            return .continue
        }

        self.childReceiver1.receiveHandler = { action in
            called.append(.init(receiver: .child1, action: action))
            return .break
        }

        self.childReceiver2.receiveHandler = { action in
            called.append(.init(receiver: .child2, action: action))
            return .continue
        }

        self.grandChildReceiver.receiveHandler = { action in
            called.append(.init(receiver: .grandChild, action: action))
            return .continue
        }

        let sender = ActionSender(rootProvider: self.rootProvider)

        XCTAssertEqual(called.count, 0)

        sender.send(.init(kind: .logout, id: nil))

        XCTAssertEqual(called.count, 2)
        XCTAssertEqual(called[0].receiver, .grandChild)
        XCTAssertEqual(called[0].action.kind, .logout)
        XCTAssertNil(called[0].action.id)
        XCTAssertEqual(called[1].receiver, .child1)
        XCTAssertEqual(called[1].action.kind, .logout)
        XCTAssertNil(called[1].action.id)
    }
}
