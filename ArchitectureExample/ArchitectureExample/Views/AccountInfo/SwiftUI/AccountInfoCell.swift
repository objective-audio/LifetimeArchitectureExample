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
        }
        
    }
}

private extension AccountInfoContent {
    enum ViewKind {
        case info
        case action
    }
    
    var kind: ViewKind {
        switch self {
        case .id, .name:
            return .info
        case .edit:
            return .action
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
