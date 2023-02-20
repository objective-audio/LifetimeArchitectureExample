//
//  CommandViewDependencies.swift
//

import Foundation

@MainActor
protocol PresenterForCommandView: ObservableObject {
    func handleCommand(_ command: Command)
}
