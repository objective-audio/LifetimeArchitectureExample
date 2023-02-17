//
//  RootTransitionView.swift
//

import SwiftUI

struct RootTransitionView<ChildPresenter: ChildPresenterForRootTransitionView,
                          ModalPresenter: ModalPresenterForRootTransitionView,
                          Factory: FactoryForRootTransitionView>: View {
    @ObservedObject var childPresenter: ChildPresenter
    @ObservedObject var modalPresenter: ModalPresenter
    let factory: Factory

    var body: some View {
        Group {
            switch childPresenter.child {
            case .login(let lifetimeId):
                if let presenter = factory.makeLoginPresenter(sceneId: lifetimeId) {
                    LoginView(presenter: presenter)
                } else {
                    Text("LoginView")
                }
            case .account(let lifetimeId):
                if let presenter = factory.makeAccountNavigationPresenter(lifetimeId: lifetimeId) {
                    AccountNavigationView<AccountNavigationPresenter,
                                          AccountNavigationViewFactory>(presenter: presenter)
                } else {
                    Text("AccountNavigationView")
                }
            case .none:
                Text("Empty")
            }
        }
        .onAppear {
            childPresenter.onAppear()
        }
        .sheet(isPresented: $modalPresenter.isAccountEditSheetPresented) {
            if let lifetimeId = modalPresenter.accountEditLifetimeId {
                if let transitionPresenter = factory.makeAccountEditTransitionPresenter(lifetimeId: lifetimeId),
                   let modalPresenter = factory.makeAccountEditModalPresenter(lifetimeId: lifetimeId) {
                    AccountEditTransitionView(
                        transitionPresenter: transitionPresenter,
                        modalPresenter: modalPresenter,
                        factory: AccountEditTransitionViewFactory()
                    )
                } else {
                    Text("AccountEditView")
                }
            } else {
                EmptyView()
            }
        }
        .alert(Text(Localized.alertLoginErrorTitle.key),
               isPresented: $modalPresenter.isLoginFailedAlertPresented,
               presenting: factory.makeAlertPresenter(lifetimeId: modalPresenter.loginFailedAlertLifetimeId)) {
            let presenter = $0

            ForEach(presenter.content.actions, id: \.self) { action in
                Button(role: action.role) {
                    presenter.doAction(action)
                } label: {
                    Text(action.title.key)
                }
            }
        } message: {
            Text($0.content.message.key)
        }
    }
}

struct RootTransitionChildView_Previews: PreviewProvider {
    class PreviewChildPresenter: ChildPresenterForRootTransitionView {
        @Published var child: RootChild?

        func onAppear() {}

        func toggleChild() {
            switch child {
            case .none:
                child = .login(lifetimeId: .init(instanceId: .init()))
            case .login:
                child = .account(lifetimeId: .init(scene: .init(instanceId: .init()),
                                                   accountId: 0))
            case .account:
                child = nil
            }
        }
    }

    class PreviewModalPresenter: ModalPresenterForRootTransitionView {
        @Published var isAccountEditSheetPresented: Bool = false {
            didSet {
                if !isAccountEditSheetPresented {
                    self.accountEditLifetimeId = nil
                }
            }
        }
        @Published var isLoginFailedAlertPresented: Bool = false {
            didSet {
                if !isLoginFailedAlertPresented {
                    self.loginFailedAlertLifetimeId = nil
                }
            }
        }

        var accountEditLifetimeId: AccountEditLifetimeId?
        var loginFailedAlertLifetimeId: RootAlertLifetimeId?
    }

    struct PreviewFactory: FactoryForRootTransitionView {
        func makeAccountEditTransitionPresenter(
            lifetimeId: AccountEditLifetimeId
        ) -> AccountEditTransitionPresenter? { nil }

        func makeAccountEditModalPresenter(
            lifetimeId: AccountEditLifetimeId
        ) -> AccountEditModalPresenter? { nil }

        func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter? { nil }

        func makeAccountNavigationPresenter(
            lifetimeId: AccountLifetimeId
        ) -> AccountNavigationPresenter? { nil }

        func makeAlertPresenter(
            lifetimeId: RootAlertLifetimeId?
        ) -> RootAlertPresenter? { nil }
    }

    static var previews: some View {
        let childPresenter: PreviewChildPresenter = .init()
        let modalPresenter: PreviewModalPresenter = .init()
        let accountLifetimeId: AccountLifetimeId = .init(scene: .init(instanceId: .init()),
                                                         accountId: 0)

        NavigationView {
            RootTransitionView(childPresenter: childPresenter,
                               modalPresenter: modalPresenter,
                               factory: PreviewFactory())
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Toggle Child") {
                            childPresenter.toggleChild()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Show Sheet") {
                            modalPresenter.accountEditLifetimeId = .init(instanceId: .init(),
                                                                         account: accountLifetimeId)
                            modalPresenter.isAccountEditSheetPresented = true
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Show Alert") {
                            modalPresenter.loginFailedAlertLifetimeId = .init(instanceId: .init(),
                                                                              scene: accountLifetimeId.scene)
                            modalPresenter.isLoginFailedAlertPresented = true
                        }
                    }
                }
        }
        .environment(\.locale, .init(identifier: "ja"))
    }
}
