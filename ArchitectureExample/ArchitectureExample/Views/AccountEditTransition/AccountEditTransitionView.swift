//
//  AccountEditTransitionView.swift
//

import UIKit
import SwiftUI

struct AccountEditTransitionView<Factory: FactoryForAccountEditTransitionView>: View {
    @ObservedObject var transitionPresenter: AccountEditTransitionPresenter
    @ObservedObject var modalPresenter: AccountEditModalPresenter

    var body: some View {
        Group {
            if let presenter = Factory.makeAccountEditPresenter(
                accountEditLifetimeId: transitionPresenter.accountEditLifetimeId
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
               isPresented: $modalPresenter.isDestructAlertPresented) {
            if case .alert(let lifetimeId, .destruct) = modalPresenter.modal,
               let presenter = Factory.makeAlertPresenter(accountEditAlertLifetimeId: lifetimeId) {
                ForEach(presenter.actions, id: \.self) { action in
                    Button(role: action.role) {
                        presenter.doAction(action)
                    } label: {
                        Text(action.title.key)
                    }
                }
            } else {
                EmptyView()
            }
        } message: {
            if case .alert(let lifetimeId, .destruct) = modalPresenter.modal,
               let presenter = Factory.makeAlertPresenter(accountEditAlertLifetimeId: lifetimeId) {
                Text(presenter.message.key)
            } else {
                EmptyView()
            }
        }
        .alert(Text(Localized.alertAccountEditLogoutTitle.key),
               isPresented: $modalPresenter.isLogoutAlertPresented) {
            if case .alert(let lifetimeId, .logout) = modalPresenter.modal,
               let presenter = Factory.makeAlertPresenter(accountEditAlertLifetimeId: lifetimeId) {
                ForEach(presenter.actions, id: \.self) { action in
                    Button(role: action.role) {
                        presenter.doAction(action)
                    } label: {
                        Text(action.title.key)
                    }
                }
            } else {
                EmptyView()
            }
        } message: {
            if case .alert(let lifetimeId, .logout) = modalPresenter.modal,
               let presenter = Factory.makeAlertPresenter(accountEditAlertLifetimeId: lifetimeId) {
                Text(presenter.message.key)
            } else {
                EmptyView()
            }
        }

    }
}
