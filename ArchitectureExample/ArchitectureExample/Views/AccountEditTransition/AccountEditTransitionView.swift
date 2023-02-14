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
        .alert(Text(Localized.alertAccountEditDestructionTitle.key),
               isPresented: $modalPresenter.isDestructAlertPresented) {
            if let alert = modalPresenter.destructAlert,
               let presenter = Factory.makeAlertPresenter(accountEditAlertLifetimeId: alert.lifetimeId) {
                ForEach(presenter.content.actions, id: \.self) { action in
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
            if let alert = modalPresenter.destructAlert,
               let presenter = Factory.makeAlertPresenter(accountEditAlertLifetimeId: alert.lifetimeId) {
                Text(presenter.content.message.key)
            } else {
                EmptyView()
            }
        }
        .alert(Text(Localized.alertAccountEditLogoutTitle.key),
               isPresented: $modalPresenter.isLogoutAlertPresented) {
            if let alert = modalPresenter.logoutAlert,
               let presenter = Factory.makeAlertPresenter(accountEditAlertLifetimeId: alert.lifetimeId) {
                ForEach(presenter.content.actions, id: \.self) { action in
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
            if let alert = modalPresenter.logoutAlert,
               let presenter = Factory.makeAlertPresenter(accountEditAlertLifetimeId: alert.lifetimeId) {
                Text(presenter.content.message.key)
            } else {
                EmptyView()
            }
        }

    }
}
