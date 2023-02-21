//
//  CommandViewDependencies.swift
//

import Foundation

protocol PresenterForCommandView: ObservableObject {
    func handleCommand(_ command: Command)
}
