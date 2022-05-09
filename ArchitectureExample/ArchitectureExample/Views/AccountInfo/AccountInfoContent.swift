//
//  AccountInfoContent.swift
//

enum AccountInfoContent: Hashable {
    case id(Int)
    case name(String)
    case edit
}

enum AccountInfoAction {
    case edit
}

extension AccountInfoContent {
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
