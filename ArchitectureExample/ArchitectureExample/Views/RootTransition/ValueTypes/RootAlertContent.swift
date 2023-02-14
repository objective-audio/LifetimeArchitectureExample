//
//  RootAlertContent.swift
//

struct RootAlertContent {
    let message: Localized
    let actions: [RootAlertAction]
}

extension RootAlertContent {
    static var empty: Self {
        .init(message: .empty,
              actions: [])
    }
}
