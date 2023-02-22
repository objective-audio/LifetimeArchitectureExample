//
//  AccountDetailView.swift
//

import SwiftUI

struct AccountDetailView<Presenter: PresenterForAccountDetailView>: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        Text("Detail")
            .navigationTitle(Localized.accountDetailNavigationTitle.key)
    }
}
