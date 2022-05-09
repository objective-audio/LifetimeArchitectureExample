//
//  RootTransitionViewController+KeyCommands.swift
//

import UIKit

extension RootTransitionViewController {
    override var canBecomeFirstResponder: Bool { true }

    override var keyCommands: [UIKeyCommand]? {
        let inputs = Command.allCases.map(\.rawValue)
        return inputs.map {
            UIKeyCommand(action: #selector(handleKeyCommand(_:)),
                         input: $0)
        }
    }
}

private extension RootTransitionViewController {
    @objc func handleKeyCommand(_ keyCommand: UIKeyCommand) {
        guard let input = keyCommand.input,
              let command = Command(rawValue: input),
              let presenter = self.commandPresenter else {
            assertionFailure()
            return
        }

        presenter.handleCommand(command)
    }
}
