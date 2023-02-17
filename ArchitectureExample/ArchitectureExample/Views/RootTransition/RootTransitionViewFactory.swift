//
//  RootTransitionViewFactory.swift
//

@MainActor
struct RootTransitionViewFactory {}

extension RootTransitionViewFactory: FactoryForRootTransitionView {}

// MARK: -

extension LoginInteractor: LoginInteractorForPresenter {}
extension LoginPresenter: PresenterForLoginView {}

extension RootTransitionViewFactory {
    func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter? {
        guard let lifetime = LifetimeAccessor.login(sceneId: sceneId) else {
            assertionFailure()
            return nil
        }

        return .init(interactor: lifetime.interactor)
    }
}

// MARK: -

extension AccountNavigationPresenter: PresenterForAccountNavigationView {}

extension RootTransitionViewFactory {
    func makeAccountNavigationPresenter(
        lifetimeId: AccountLifetimeId
    ) -> AccountNavigationPresenter? {
        guard let lifetime = LifetimeAccessor.account(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(accountLifetimeId: lifetimeId,
                     navigationLifecycle: lifetime.navigationLifecycle)
    }
}

// MARK: -

extension AccountEditTransitionPresenter: TransitionPresenterForAccountEditTransitionView {}
extension AccountEditModalPresenter: ModalPresenterForAccountEditTransitionView {}

extension RootTransitionViewFactory {
    func makeAccountEditTransitionPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionPresenter? {
        guard let accountEditLifetime = LifetimeAccessor.accountEdit(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(accountEditLifetimeId: lifetimeId,
                     accountEditInteractor: accountEditLifetime.interactor)
    }

    func makeAccountEditModalPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditModalPresenter? {
        guard let accountEditLifetime = LifetimeAccessor.accountEdit(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(lifecycle: accountEditLifetime.modalLifecycle)
    }
}

// MARK: -

extension RootTransitionViewFactory {
    func makeAlertPresenter(
        lifetimeId: RootAlertLifetimeId?
    ) -> RootAlertPresenter? {
        guard let lifetimeId else { return nil }

        guard let lifetime = LifetimeAccessor.rootAlert(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(interactor: lifetime.interactor)
    }
}
