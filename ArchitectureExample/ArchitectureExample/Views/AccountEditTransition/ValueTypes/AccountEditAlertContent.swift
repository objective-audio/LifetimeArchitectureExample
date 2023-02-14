//
//  AccountEditAlertContent.swift
//

import Foundation

struct AccountEditAlertContent {
    let message: Localized
    let actions: [AccountEditAlertAction]
}

extension AccountEditAlertContent {
    static var empty: Self {
        .init(message: .empty,
              actions: [])
    }
}
