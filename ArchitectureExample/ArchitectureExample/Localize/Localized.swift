//
//  Localized.swift
//

import SwiftUI

enum Localized: String, CaseIterable {
    case alertLoginErrorTitle
    case alertLoginFailedMessage
    case alertLoginAccountDuplicatedMessage
    case alertLoginInvalidAccountIDMessage
    case alertLoginCancelledMessage
    
    case alertOK
    
    case loginButtonTitle
    case loginAccountIdPlaceholder
    case loginCancelButtonTitle
    
    case accountMenuInfoHeader
    case accountMenuContentSwiftUI
    case accountMenuContentUIKit
    case accountMenuLogout
    
    case accountInfoNavigationTitle
    case accountInfoCaptionId
    case accountInfoCaptionName
    case accountInfoEdit
    
    case accountEditTitle
    case accountEditSaveButtonTitle
    case accountEditCancelButtonTitle
    
    case alertAccountEditDestructionTitle
    case alertAccountEditDestructionMessage
    case alertAccountEditDestruct
    case alertAccountEditCancel
}

extension Localized {
    var key: LocalizedStringKey { .init(self.rawValue) }
    var value: String { NSLocalizedString(rawValue, comment: "") }
}
