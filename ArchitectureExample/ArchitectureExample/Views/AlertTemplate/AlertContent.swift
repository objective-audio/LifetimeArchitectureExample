//
//  AlertContent.swift
//

import UIKit

struct AlertContent<ID: Equatable> {
    struct Action {
        let title: String
        let style: UIAlertAction.Style
        let handler: () -> Void
    }

    let id: ID
    let title: String
    let message: String
    let actions: [Action]
}
