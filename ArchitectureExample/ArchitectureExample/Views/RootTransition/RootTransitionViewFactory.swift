//
//  RootTransitionViewFactory.swift
//

@MainActor
enum RootTransitionViewFactory {}

extension RootTransitionViewFactory: FactoryForRootTransitionView {}

// MARK: -

extension LoginInteractor: LoginInteractorForPresenter {}
extension LoginPresenter: PresenterForLoginView {}

extension RootTransitionViewFactory {
    static func makeLoginPresenter(sceneId: SceneLifetimeId) -> LoginPresenter? {
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
    static func makeAccountNavigationPresenter(
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
    static func makeAccountEditTransitionPresenter(
        lifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionPresenter? {
        guard let accountEditLifetime = LifetimeAccessor.accountEdit(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(accountEditLifetimeId: lifetimeId,
                     accountEditInteractor: accountEditLifetime.interactor)
    }

    static func makeAccountEditModalPresenter(
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
    static func makeAlertPresenter(
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
