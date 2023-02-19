//
//  ArchitectureExampleApp.swift
//

import SwiftUI

@main
struct ArchitectureExampleApp: App {
    let presenter: AppPresenter?

    init() {
        self.presenter = Self.makeAppPresenter()
        self.presenter?.didFinishLaunching()
    }

    var body: some Scene {
        ArchitectureExampleScene()
    }
}

@MainActor
private extension ArchitectureExampleApp {
    static func makeAppPresenter() -> AppPresenter? {
        if isNotTest {
            return .init(appLifecycle: LifetimeAccessor.appLifecycle)
        } else {
            return nil
        }
    }
}
