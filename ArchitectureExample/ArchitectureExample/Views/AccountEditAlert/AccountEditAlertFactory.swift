//
//  AccountEditAlertFactory.swift
//

import UIKit

extension AccountEditModalLevelRouter: RouterForAlertPresenter {}

@MainActor
func makeAccountEditAlertController(accountLevelId: AccountLevelId,
                                    content: AccountEditAlertContent) -> UIAlertController? {
    guard let accountEditLevel = LevelAccessor.accountEdit(id: accountLevelId) else {
        assertionFailure()
        return nil
    }
    
    let presenter = AlertPresenter(content: .init(content,
                                                  interactor: accountEditLevel.interactor),
                                   router: accountEditLevel.modalRouter)
    
    return makeAlertController(presenter: presenter)
}

// MARK: -

private extension AccountEditAlertContent {
    var localizedTitle: Localized {
        switch self {
        case .destruct:
            return .alertAccountEditDestructionTitle
        }
    }
    
    var localizedMessage: Localized {
        switch self {
        case .destruct:
            return .alertAccountEditDestructionMessage
        }
    }
    
    @MainActor
    func actions(interactor: AccountEditInteractor) -> [AlertContent<Self>.Action] {
        switch self {
        case .destruct:
            return [.init(title: Localized.alertAccountEditCancel.value,
                          style: .cancel,
                          handler: {}),
                    .init(title: Localized.alertAccountEditDestruct.value,
                          style: .destructive,
                          handler: { [weak interactor] in interactor?.finalize() })]
        }
    }
}

private extension AlertContent where ID == AccountEditAlertContent {
    @MainActor
    init(_ content: AccountEditAlertContent,
         interactor: AccountEditInteractor) {
        self.init(id: content,
                  title: content.localizedTitle.value,
                  message: content.localizedMessage.value,
                  actions: content.actions(interactor: interactor))
    }
}
