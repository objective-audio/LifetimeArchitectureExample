//
//  AccountInfoContent.swift
//

enum AccountInfoContent: Hashable, Identifiable {
    case id(Int)
    case name(String)
    case edit
    case pushDetail
}

enum AccountInfoContentID: Hashable {
    case id
    case name
    case edit
    case pushDetail
}

enum AccountInfoAction {
    case edit
    case pushDetail
}

extension AccountInfoContent {
    var id: AccountInfoContentID {
        switch self {
        case .id:
            return .id
        case .name:
            return .name
        case .edit:
            return .edit
        case .pushDetail:
            return .pushDetail
        }
    }

    var localizedCaption: Localized {
        switch self {
        case .id:
            return .accountInfoCaptionId
        case .name:
            return .accountInfoCaptionName
        case .edit:
            return .accountInfoEdit
        case .pushDetail:
            return .accountInfoPushDetail
        }
    }

    var secondaryText: String {
        switch self {
        case .id(let value):
            return "\(value)"
        case .name(let value):
            return value
        case .edit, .pushDetail:
            return ""
        }
    }

    var action: AccountInfoAction? {
        switch self {
        case .edit:
            return .edit
        case .pushDetail:
            return .pushDetail
        case .id, .name:
            return nil
        }
    }
}
