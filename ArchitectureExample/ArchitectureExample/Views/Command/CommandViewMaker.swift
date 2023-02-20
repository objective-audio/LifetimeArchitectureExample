//
//  CommandViewMaker.swift
//

protocol CommandViewMakeable {
    static func makeCommandPresnter(
        sceneLifetimeId: SceneLifetimeId
    ) -> CommandPresenter?
}

@MainActor
enum CommandViewMaker {}

extension CommandViewMaker: CommandViewMakeable {
    static func makeCommandPresnter(
        sceneLifetimeId: SceneLifetimeId
    ) -> CommandPresenter? {
        guard let appLifetime = LifetimeAccessor.app else {
            assertionFailure()
            return nil
        }

        return .init(sceneLifetimeId: sceneLifetimeId,
                     actionSender: appLifetime.actionSender)
    }
}
