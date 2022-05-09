//
//  RootAlertFactory.swift
//

import UIKit

extension RootModalLevelRouter: RouterForAlertPresenter {}

@MainActor
func makeRootAlertController(sceneLevelId: SceneLevelId,
                             content: RootAlertContent) -> UIAlertController? {
    guard let sceneLevel = LevelAccessor.scene(id: sceneLevelId) else {
        assertionFailure()
        return nil
    }
    
    let presenter = AlertPresenter(content: .init(content),
                                   router: sceneLevel.rootModalRouter)
    
    return makeAlertController(presenter: presenter)
}

// MARK: -

private extension RootAlertContent {
    var localizedTitle: Localized {
        switch self {
        case .loginFailed:
            return .alertLoginErrorTitle
        }
    }
    
    var localizedMessage: Localized {
        switch self {
        case .loginFailed(let kind):
            switch kind {
            case .accountDuplicated:
                return .alertLoginAccountDuplicatedMessage
            case .invalidAccountID:
                return .alertLoginInvalidAccountIDMessage
            case .cancelled:
                return .alertLoginCancelledMessage
            case .other:
                return .alertLoginFailedMessage
            }
        }
    }
    
    var actions: [AlertContent<Self>.Action] {
        switch self {
        case .loginFailed:
            return [.init(title: Localized.alertOK.value,
                          style: .default,
                          handler: {})]
        }
    }
}

private extension AlertContent where ID == RootAlertContent {
    init(_ content: RootAlertContent) {
        self.init(id: content,
                  title: content.localizedTitle.value,
                  message: content.localizedMessage.value,
                  actions: content.actions)
    }
}
