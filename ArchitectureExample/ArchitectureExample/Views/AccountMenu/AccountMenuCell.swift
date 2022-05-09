//
//  AccountMenuCell.swift
//

import SwiftUI

struct AccountMenuCell: View {
    let content: AccountMenuContent

    var body: some View {
        switch content.kind {
        case .navigation:
            HStack {
                Text(content.localizedText.key)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(.system(.caption).weight(.bold))
                    .foregroundColor(.init(.tertiaryLabel))
                    .layoutPriority(1)
            }
        case .action:
            Text(content.localizedText.key)
        }
    }
}

private extension AccountMenuContent {
    enum ViewKind {
        case navigation
        case action
    }

    var kind: ViewKind {
        switch self {
        case .info:
            return .navigation
        case .logout:
            return .action
        }
    }
}

private extension AccountMenuContent {
    var localizedText: Localized {
        switch self {
        case .info(let uiSystem):
            switch uiSystem {
            case .swiftUI:
                return .accountMenuContentSwiftUI
            case .uiKit:
                return .accountMenuContentUIKit
            }
        case .logout:
            return .accountMenuLogout
        }
    }
}

struct AccountMenuCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                AccountMenuCell(content: .info(.swiftUI))
                AccountMenuCell(content: .info(.uiKit))
                AccountMenuCell(content: .logout)
            }
        }
        .environment(\.locale, .init(identifier: "ja"))
    }
}
