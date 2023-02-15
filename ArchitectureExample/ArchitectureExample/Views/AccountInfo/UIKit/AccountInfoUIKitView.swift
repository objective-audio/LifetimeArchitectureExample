//
//  AccountInfoUIKitView.swift
//

import SwiftUI

struct AccountInfoUIKitView: View {
    let presenter: AccountInfoUIKitPresenter

    var body: some View {
        AccountInfoUIKitViewRepresentation(presenter: presenter)
            .background(Color(.systemGroupedBackground))
            .navigationTitle(Localized.accountInfoNavigationTitle.key)
    }
}

struct AccountInfoUIKitViewRepresentation: UIViewControllerRepresentable {
    let presenter: AccountInfoUIKitPresenter

    func makeUIViewController(context: Context) -> AccountInfoViewController {
        AccountInfoViewController.instantiate(presenter: self.presenter)
    }

    func updateUIViewController(_ uiViewController: AccountInfoViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {}
}
