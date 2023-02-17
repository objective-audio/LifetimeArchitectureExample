//
//  AccountEditTransitionView.swift
//

import SwiftUI

struct AccountEditTransitionView<Factory: FactoryForAccountEditTransitionView>: View {
    @ObservedObject var transitionPresenter: AccountEditTransitionPresenter
    @ObservedObject var modalPresenter: AccountEditModalPresenter

    var body: some View {
        Group {
            if let presenter = Factory.makeAccountEditPresenter(
                lifetimeId: transitionPresenter.accountEditLifetimeId
            ) {
                AccountEditView(presenter: presenter)
            } else {
                Text("AccountEditTransitionView")
            }
        }
        .interactiveDismissDisabled(transitionPresenter.interactiveDismissDisabled)
        .onDisappear {
            transitionPresenter.onDisappear()
        }
        .alert(Text(Localized.alertAccountEditDestructionTitle.key),
               isPresented: $modalPresenter.isDestructAlertPresented,
               presenting: Factory.makeAlertPresenter(lifetimeId: modalPresenter.destructAlertLifetimeId)) {
            let presenter = $0

            ForEach(presenter.actions, id: \.self) { action in
                Button(role: action.role) {
                    presenter.doAction(action)
                } label: {
                    Text(action.title.key)
                }
            }
        } message: {
            Text($0.message.key)
        }
        .alert(Text(Localized.alertAccountEditLogoutTitle.key),
               isPresented: $modalPresenter.isLogoutAlertPresented,
               presenting: Factory.makeAlertPresenter(lifetimeId: modalPresenter.logoutAlertLifetimeId)) {
            let presenter = $0

            ForEach(presenter.actions, id: \.self) { action in
                Button(role: action.role) {
                    presenter.doAction(action)
                } label: {
                    Text(action.title.key)
                }
            }
        } message: {
            Text($0.message.key)
        }
    }
}
