//
//  RootTransitionViewController+ViewFactory.swift
//

// MARK: -

extension RootTransitionViewController {
    static func makeAccountEditTransitionViewController(
        accountEditLifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionViewController? {
        guard let accountEditLifetime = LifetimeAccessor.accountEdit(id: accountEditLifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(presenter: .init(accountEditLifetimeId: accountEditLifetimeId,
                                      accountEditInteractor: accountEditLifetime.interactor),
                     modalPresenter: .init(sourcePublisher: accountEditLifetime.modalLifecycle.$current))
    }
}

// MARK: -

extension LoginInteractor: LoginPresenter.Interactor {}
extension LoginPresenter: LoginView.Presenter {}

extension RootTransitionViewController {
    static func makeLoginHostingController(sceneId: SceneLifetimeId) -> LoginHostingController? {
        guard let lifetime = LifetimeAccessor.login(sceneId: sceneId) else {
            assertionFailure()
            return nil
        }

        let presenter = LoginPresenter(interactor: lifetime.interactor)

        return .init(presenter: presenter)
    }
}

// MARK: -

extension RootTransitionViewController {
    static func makeAccountNavigationController(accountLifetimeId: AccountLifetimeId) -> AccountNavigationController? {
        guard let lifetime = LifetimeAccessor.account(id: accountLifetimeId) else { return nil }
        let presenter = AccountNavigationPresenter(navigationLifecycle: lifetime.navigationLifecycle)
        return AccountNavigationController.instantiate(presenter: presenter)
    }
}
