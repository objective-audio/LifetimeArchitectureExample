//
//  AccountInfoContent.swift
//

enum AccountInfoContent: Hashable, Identifiable {
    case id(Int)
    case name(String)
    case edit
}

enum AccountInfoContentID: Hashable {
    case id
    case name
    case edit
}

enum AccountInfoAction {
    case edit
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
        }
    }

    var secondaryText: String {
        switch self {
        case .id(let value):
            return "\(value)"
        case .name(let value):
            return value
        case .edit:
            return ""
        }
    }

    var action: AccountInfoAction? {
        switch self {
        case .edit:
            return .edit
        case .id, .name:
            return nil
        }
    }
}
