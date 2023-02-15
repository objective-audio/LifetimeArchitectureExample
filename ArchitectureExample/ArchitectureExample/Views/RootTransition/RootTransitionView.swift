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
            if case .accountEdit(let lifetimeId) = modalPresenter.modal {
                if let transitionPresenter = Factory.makeAccountEditTransitionPresenter(lifetimeId: lifetimeId),
                   let modalPresenter = Factory.makeAccountEditTransitionModalPresenter(lifetimeId: lifetimeId) {
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
            if case .alert(let lifetimeId) = modalPresenter.modal,
               let presenter = Factory.makeAlertPresenter(lifetimeId: lifetimeId) {
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
            if case .alert(let lifetimeId) = modalPresenter.modal,
               let presenter = Factory.makeAlertPresenter(lifetimeId: lifetimeId) {
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
                    self.modal = nil
                }
            }
        }
        @Published var isLoginFailedAlertPresented: Bool = false {
            didSet {
                if !isLoginFailedAlertPresented {
                    self.modal = nil
                }
            }
        }

        var modal: RootModal?
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
                            modalPresenter.modal = .accountEdit(lifetimeId: .init(instanceId: .init(),
                                                                                  account: accountLifetimeId))
                            modalPresenter.isAccountEditSheetPresented = true
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Show Alert") {
                            modalPresenter.modal = .alert(lifetimeId: .init(instanceId: .init(),
                                                                            scene: accountLifetimeId.scene))
                            modalPresenter.isLoginFailedAlertPresented = true
                        }
                    }
                }
        }
        .environment(\.locale, .init(identifier: "ja"))
    }
}
