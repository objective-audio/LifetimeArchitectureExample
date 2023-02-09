//
//  AccountDetailView.swift
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject private var presenter: AccountDetailPresenter

    init(presenter: AccountDetailPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        Text("Detail")
            .navigationTitle(Localized.accountDetailNavigationTitle.key)
    }
}
