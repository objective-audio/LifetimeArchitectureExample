//
//  RootAlertContent.swift
//

enum RootAlertContent: Equatable {
    enum LoginFailedKind {
        case accountDuplicated
        case invalidAccountID
        case cancelled
        case other
    }
    
    case loginFailed(LoginFailedKind)
}
