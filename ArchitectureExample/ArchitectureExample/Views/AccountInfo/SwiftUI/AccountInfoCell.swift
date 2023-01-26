//
//  AccountInfoCell.swift
//

import SwiftUI

struct AccountInfoCell: View {
    let content: AccountInfoContent

    var body: some View {
        switch content.kind {
        case .info:
            HStack {
                Text(content.localizedCaption.key)
                    .layoutPriority(1)
                Spacer()
                Text(content.secondaryText)
                    .foregroundColor(.secondary)
            }
        case .action:
            Text(content.localizedCaption.key)
        case .navigation:
            HStack {
                Text(content.localizedCaption.key)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(.system(.caption).weight(.bold))
                    .foregroundColor(.init(.tertiaryLabel))
                    .layoutPriority(1)
            }
        }

    }
}

private extension AccountInfoContent {
    enum ViewKind {
        case info
        case action
        case navigation
    }

    var kind: ViewKind {
        switch self {
        case .id, .name:
            return .info
        case .edit:
            return .action
        case .pushDetail:
            return .navigation
        }
    }
}

struct AccountInfoCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                AccountInfoCell(content: .id(123))
                AccountInfoCell(content: .name("name"))
            }
            Section {
                AccountInfoCell(content: .edit)
            }
        }
        .environment(\.locale, .init(identifier: "ja"))
    }
}
