//
//  RootTransitionView.swift
//

import SwiftUI

struct RootTransitionView<ChildPresenter: ChildPresenterForRootTransitionView,
                          ModalPresenter: ModalPresenterForRootTransitionView,
                          Factory: FactoryForRootTransitionView>: View {
    @ObservedObject var childPresenter: ChildPresenter
    @ObservedObject var modalPresenter: ModalPresenter

    init(childPresenter: ChildPresenter,
         modalPresenter: ModalPresenter,
         factory: Factory.Type) {
        self.childPresenter = childPresenter
        self.modalPresenter = modalPresenter
    }

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
                    AccountNavigationView(presenter: presenter,
                                          factory: AccountNavigationViewFactory())
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
                if let transitionPresenter = Factory.makeAccountEditTransitionPresenter(lifetimeId: lifetimeId),
                   let modalPresenter = Factory.makeAccountEditModalPresenter(lifetimeId: lifetimeId) {
                    AccountEditTransitionView(
                        transitionPresenter: transitionPresenter,
                        modalPresenter: modalPresenter,
                        factory: AccountEditTransitionViewFactory.self
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
               presenting: Factory.makeAlertPresenter(lifetimeId: modalPresenter.loginFailedAlertLifetimeId)) {
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
        static func makeAccountEditTransitionPresenter(
            lifetimeId: AccountEditLifetimeId
        ) -> AccountEditTransitionPresenter? { nil }

        static func makeAccountEditModalPresenter(
            lifetimeId: AccountEditLifetimeId
        ) -> AccountEditModalPresenter? { nil }

        static func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter? { nil }

        static func makeAccountNavigationPresenter(
            lifetimeId: AccountLifetimeId
        ) -> AccountNavigationPresenter? { nil }

        static func makeAlertPresenter(
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
                               factory: PreviewFactory.self)
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
