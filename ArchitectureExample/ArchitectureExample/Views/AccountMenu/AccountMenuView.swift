//
//  AccountMenuView.swift
//

import SwiftUI

struct AccountMenuView<Presenter: PresenterForAccountMenuView>: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        List {
            ForEach(presenter.sections, id: \.kind) { section in
                Section(header: Text(section.localizedHeaderText?.key ?? "")) {
                    ForEach(section.contents, id: \.self) { content in
                        Button {
                            presenter.didSelect(content: content)
                        } label: {
                            AccountMenuCell(content: content)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(presenter.title)
    }
}

private extension AccountMenuSection {
    var localizedHeaderText: Localized? {
        switch self.kind {
        case .info:
            return Localized.accountMenuInfoHeader
        case .logout:
            return nil
        }
    }
}

struct AccountMenuView_Previews: PreviewProvider {
    private class PreviewPresenter: PresenterForAccountMenuView {
        let sections: [AccountMenuSection] = [
            .init(kind: .info,
                  contents: [.info(.swiftUI), .info(.uiKit)]),
            .init(kind: .logout,
                  contents: [.logout])]

        let title: String = "title"

        func didSelect(content: AccountMenuContent) {}
    }

    static var previews: some View {
        NavigationView {
            AccountMenuView(presenter: PreviewPresenter())
        }
        .navigationViewStyle(.stack)
        .environment(\.locale, .init(identifier: "ja"))
    }
}
