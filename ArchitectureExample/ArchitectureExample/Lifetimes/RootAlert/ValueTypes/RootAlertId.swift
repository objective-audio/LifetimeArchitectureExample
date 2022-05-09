//
//  RootAlertId.swift
//

/**
 ルートの階層で表示するアラートの種類
 */

enum RootAlertId: Equatable {
    enum LoginFailedKind {
        case accountDuplicated
        case invalidAccountID
        case cancelled
        case other
    }

    case loginFailed(LoginFailedKind)
}
