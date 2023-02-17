//
//  AccountEditTransitionView.swift
//

import SwiftUI

struct AccountEditTransitionView<TransitionPresenter: TransitionPresenterForAccountEditTransitionView,
                                 ModalPresenter: ModalPresenterForAccountEditTransitionView,
                                 Factory: FactoryForAccountEditTransitionView>: View {
    @ObservedObject var transitionPresenter: TransitionPresenter
    @ObservedObject var modalPresenter: ModalPresenter
    let factory: Factory

    var body: some View {
        Group {
            if let presenter = factory.makeAccountEditPresenter(
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
               presenting: factory.makeAlertPresenter(lifetimeId: modalPresenter.destructAlertLifetimeId)) {
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
               presenting: factory.makeAlertPresenter(lifetimeId: modalPresenter.logoutAlertLifetimeId)) {
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

struct AccountEditTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        Text("TODO")
            .environment(\.locale, .init(identifier: "ja"))
    }
}
