//
//  RootTransitionView.swift
//

import SwiftUI

struct RootTransitionView<ChildPresenter: ChildPresenterForRootTransitionView,
                          ModalPresenter: ModalPresenterForRootTransitionView,
                          Factory: FactoryForRootTransitionView>: View {
    @ObservedObject var childPresenter: ChildPresenter
    @ObservedObject var modalPresenter: ModalPresenter

    var body: some View {
        Group {
            switch childPresenter.child {
            case .login(let lifetimeId):
                if let presenter = Factory.makeLoginPresenter(sceneId: lifetimeId) {
                    LoginView(presenter: presenter)
                } else {
                    Text("LoginView")
                }
            case .account(let lifetimeId):
                if let presenter = Factory.makeAccountNavigationPresenter(lifetimeId: lifetimeId) {
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
            childPresenter.viewDidAppear()
        }
        .sheet(isPresented: $modalPresenter.isAccountEditSheetPresented) {
            if let sheet = modalPresenter.accountEditSheet {
                if let transitionPresenter = Factory.makeAccountEditTransitionPresenter(lifetimeId: sheet.lifetimeId),
                   let modalPresenter = Factory.makeAccountEditTransitionModalPresenter(lifetimeId: sheet.lifetimeId) {
                    AccountEditTransitionView<AccountEditTransitionViewFactory>(
                        transitionPresenter: transitionPresenter,
                        modalPresenter: modalPresenter
                    )
                } else {
                    Text("AccountEditView")
                }
            } else {
                EmptyView()
            }
        }
        .alert(Text(Localized.alertLoginErrorTitle.key),
               isPresented: $modalPresenter.isLoginFailedAlertPresented) {
            if let alert = modalPresenter.loginFailedAlert,
               let presenter = Factory.makeAlertPresenter(lifetimeId: alert.lifetimeId) {
                ForEach(presenter.content.actions, id: \.title) { action in
                    Button(role: action.role) {
                        action.handler()
                    } label: {
                        Text(action.title.key)
                    }
                }
            } else {
                EmptyView()
            }
        } message: {
            if let alert = modalPresenter.loginFailedAlert,
               let presenter = Factory.makeAlertPresenter(lifetimeId: alert.lifetimeId) {
                Text(presenter.content.message.key)
            } else {
                EmptyView()
            }
        }
    }
}

struct RootTransitionChildView_Previews: PreviewProvider {
    class PreviewChildPresenter: ChildPresenterForRootTransitionView {
        @Published var child: RootChild?

        func viewDidAppear() {}

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
                    self.accountEditSheet = nil
                }
            }
        }
        @Published var isLoginFailedAlertPresented: Bool = false {
            didSet {
                if !isLoginFailedAlertPresented {
                    self.loginFailedAlert = nil
                }
            }
        }

        var accountEditSheet: RootAccountEditSheet?
        var loginFailedAlert: RootLoginFailedAlert?
    }

    enum PreviewFactory: FactoryForRootTransitionView {
        static func makeAccountEditTransitionPresenter(
            lifetimeId: AccountEditLifetimeId
        ) -> AccountEditTransitionPresenter? { nil }

        static func makeAccountEditTransitionModalPresenter(
            lifetimeId: AccountEditLifetimeId
        ) -> AccountEditModalPresenter? { nil }

        static func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter? { nil }

        static func makeAccountNavigationPresenter(
            lifetimeId: AccountLifetimeId
        ) -> AccountNavigationPresenter? { nil }

        static func makeAlertPresenter(
            lifetimeId: RootAlertLifetimeId
        ) -> RootAlertPresenter? { nil }
    }

    static var previews: some View {
        let childPresenter: PreviewChildPresenter = .init()
        let modalPresenter: PreviewModalPresenter = .init()
        let accountLifetimeId: AccountLifetimeId = .init(scene: .init(instanceId: .init()),
                                                         accountId: 0)

        NavigationView {
            RootTransitionView<PreviewChildPresenter,
                               PreviewModalPresenter,
                               PreviewFactory>(childPresenter: childPresenter,
                                               modalPresenter: modalPresenter)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Toggle Child") {
                            childPresenter.toggleChild()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Show Sheet") {
                            modalPresenter.accountEditSheet = .init(lifetimeId: .init(instanceId: .init(),
                                                                                      account: accountLifetimeId))
                            modalPresenter.isAccountEditSheetPresented = true
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Show Alert") {
                            modalPresenter.loginFailedAlert = .init(lifetimeId: .init(instanceId: .init(),
                                                                                      scene: accountLifetimeId.scene))
                            modalPresenter.isLoginFailedAlertPresented = true
                        }
                    }
                }
        }
        .environment(\.locale, .init(identifier: "ja"))
    }
}
