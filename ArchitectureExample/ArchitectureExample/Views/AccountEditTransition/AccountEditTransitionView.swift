//
//  AccountEditTransitionView.swift
//

import UIKit
import SwiftUI

struct AccountEditTransitionView: View {
    let presenter: AccountEditTransitionPresenter
    let modalPresenter: AccountEditTransitionModalPresenter

    var body: some View {
         AccountEditTransitionViewRepresentation(presenter: presenter,
                                                 modalPresenter: modalPresenter)
    }
}

struct AccountEditTransitionViewRepresentation: UIViewControllerRepresentable {
    let presenter: AccountEditTransitionPresenter
    let modalPresenter: AccountEditTransitionModalPresenter

    func makeUIViewController(context: Context) -> AccountEditTransitionViewController {
        AccountEditTransitionViewController(presenter: presenter,
                                            modalPresenter: modalPresenter)
    }

    func updateUIViewController(_ uiViewController: AccountEditTransitionViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {}
}
