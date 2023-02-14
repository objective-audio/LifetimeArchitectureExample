//
//  AccountDetailView.swift
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject var presenter: AccountDetailPresenter

    var body: some View {
        Text("Detail")
            .navigationTitle(Localized.accountDetailNavigationTitle.key)
    }
}
