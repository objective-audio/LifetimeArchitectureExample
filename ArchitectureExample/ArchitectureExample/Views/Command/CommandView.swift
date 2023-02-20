//
//  CommandView.swift
//

import SwiftUI

struct CommandView<Presenter: PresenterForCommandView>: View {
    @ObservedObject private var presenter: Presenter

    init(presenter: Presenter) {
        self.presenter = presenter
    }

    var body: some View {
        ForEach(Command.allCases, id: \.self) { command in
            Button("") {
                presenter.handleCommand(command)
            }
            .keyboardShortcut(.init(command.rawValue),
                              modifiers: [])
        }
    }
}
