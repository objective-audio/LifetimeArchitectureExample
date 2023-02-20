//
//  RootKeyCommandPresenter.swift
//

enum Command: Character, CaseIterable {
    case keyL = "l"
    case keyR = "r"
}

@MainActor
final class CommandPresenter: PresenterForCommandView {
    private let sceneLifetimeId: SceneLifetimeId
    private weak var actionSender: ActionSender?

    init(sceneLifetimeId: SceneLifetimeId,
         actionSender: ActionSender) {
        self.sceneLifetimeId = sceneLifetimeId
        self.actionSender = actionSender
    }

    func handleCommand(_ command: Command) {
        self.actionSender?.send(.init(kind: command.actionKind,
                                      id: .init(sceneLifetimeId: self.sceneLifetimeId)))
    }
}

private extension Command {
    var actionKind: ActionKind {
        switch self {
        case .keyL:
            return .logout
        case .keyR:
            return .reopenEdit
        }
    }
}
