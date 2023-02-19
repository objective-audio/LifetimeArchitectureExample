//
//  RootLifecycleTests.swift
//

import XCTest
@testable import ArchitectureExample

private struct LaunchLifetimeStub: LaunchLifetimeForLifecycle {
    let sceneLifetimeId: SceneLifetimeId
    var interactor: LaunchInteractor { fatalError() }
}

private struct LoginLifetimeStub: LoginLifetimeForLifecycle {
    let sceneLifetimeId: SceneLifetimeId
    var network: LoginNetwork { fatalError() }
    var interactor: LoginInteractor { fatalError() }
}

private struct AccountLifetimeStub: AccountLifetimeForLifecycle {
    let lifetimeId: AccountLifetimeId
    var accountHolder: AccountHolder { fatalError() }
    var logoutInteractor: LogoutInteractor { fatalError() }
    var navigationLifecycle: AccountNavigationLifecycle<AccountNavigationFactory> { fatalError() }
    var accountMenuInteractor: AccountMenuInteractor { fatalError() }
    var receiver: AccountReceiver { fatalError() }
}

private enum FactoryStub: FactoryForRootLifecycle {
    static func makeLaunchLifetime(sceneLifetimeId: SceneLifetimeId,
                                   rootLifecycle: RootLifecycle<Self>) -> LaunchLifetimeStub {
        .init(sceneLifetimeId: sceneLifetimeId)
    }

    static func makeLoginLifetime(sceneLifetimeId: SceneLifetimeId) -> LoginLifetimeStub {
        .init(sceneLifetimeId: sceneLifetimeId)
    }

    static func makeAccountLifetime(id: AccountLifetimeId) -> AccountLifetimeStub {
        .init(lifetimeId: id)
    }
}

@MainActor
class RootLifecycleTests: XCTestCase {
    private var sceneLifetimeId: SceneLifetimeId!

    @MainActor
    override func setUpWithError() throws {
        self.sceneLifetimeId = .init(uuid: .init())
    }

    @MainActor
    override func tearDownWithError() throws {
        self.sceneLifetimeId = nil
    }

    func testSwitch() {
        let lifecycle = RootLifecycle<FactoryStub>(sceneLifetimeId: self.sceneLifetimeId)

        guard case .launch = lifecycle.current else {
            XCTFail("currentの内容が不正")
            return
        }

        lifecycle.switchToLogin()

        guard case .login = lifecycle.current else {
            XCTFail("currentの内容が不正")
            return
        }

        lifecycle.switchToAccount(account: .init(id: 123, name: "test-name-123"))

        guard case .account = lifecycle.current else {
            XCTFail("currentの内容が不正")
            return
        }
    }
}
