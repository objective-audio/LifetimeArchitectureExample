//
//  AlertContent.swift
//

import SwiftUI

struct AlertContent {
    struct Action {
        let title: Localized
        let role: ButtonRole
        let handler: () -> Void
    }

    let message: Localized
    let actions: [Action]
}

extension AlertContent {
    static var empty: AlertContent {
        .init(message: .empty, actions: [])
    }
}
