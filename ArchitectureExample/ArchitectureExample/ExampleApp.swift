//
//  ExampleApp.swift
//

import SwiftUI

@main
struct ExampleApp: App {
    let presenter: AppPresenter?

    init() {
        self.presenter = Self.makeAppPresenter()
        self.presenter?.didFinishLaunching()
    }

    var body: some Scene {
        ExampleScene()
    }
}

@MainActor
private extension ExampleApp {
    static func makeAppPresenter() -> AppPresenter? {
        if isNotTest {
            return .init(appLifecycle: LifetimeAccessor.appLifecycle)
        } else {
            return nil
        }
    }
}
