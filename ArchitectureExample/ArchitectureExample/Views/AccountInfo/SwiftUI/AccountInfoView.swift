//
//  AccountInfoView.swift
//

import SwiftUI

struct AccountInfoView<Presenter: PresenterForAccountInfoView>: View {
    typealias Presenter = PresenterForAccountInfoView

    @ObservedObject private var presenter: Presenter

    init(presenter: Presenter) {
        self.presenter = presenter
    }

    var body: some View {
        List {
            ForEach(0..<presenter.contents.count, id: \.self) { sectionIndex in
                Section {
                    ForEach(presenter.contents[sectionIndex], id: \.id) { content in
                        if let action = content.action {
                            Button {
                                presenter.handle(action: action)
                            } label: {
                                AccountInfoCell(content: content)
                            }
                        } else {
                            AccountInfoCell(content: content)
                        }
                    }
                }
            }
        }
    }
}

struct AccountInfoView_Previews: PreviewProvider {
    private class PresenterStub: AccountInfoView.Presenter {
        let title: Localized = .accountInfoNavigationTitle
        let contents: [[AccountInfoContent]] = [[.id(1), .name("account-name-1")],
                                                [.edit]]

        func handle(action: AccountInfoAction) {}
    }

    static var previews: some View {
        NavigationView {
            AccountInfoView(presenter: PresenterStub())
        }
        .navigationViewStyle(.stack)
        .environment(\.locale, .init(identifier: "ja"))
    }
}

private extension AccountInfoAction {
    var color: Color {
        switch self {
        case .edit:
            return .blue
        case .pushDetail:
            return .primary
        }
    }
}
