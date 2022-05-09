//
//  AccountInfoView.swift
//

import SwiftUI

struct AccountInfoView<Presenter: PresenterForAccountInfoView>: View {
    @ObservedObject private var presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        List {
            ForEach(presenter.sections, id: \.self) { section in
                Section {
                    ForEach(section, id: \.self) { content in
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
    private class PresenterStub: PresenterForAccountInfoView {
        let title: Localized = .accountInfoNavigationTitle
        let sections: [[AccountInfoContent]] = [[.id(1), .name("account-1")],
                                                [.edit]]
        
        func handle(action: AccountInfoAction) {}
    }
    
    static var previews: some View {
        NavigationView {
            AccountInfoView(presenter: PresenterStub())
        }
        .environment(\.locale, .init(identifier: "ja"))
    }
}
