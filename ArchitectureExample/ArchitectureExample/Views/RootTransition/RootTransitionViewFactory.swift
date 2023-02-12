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
        accountLifetimeId: AccountLifetimeId
    ) -> AccountNavigationPresenter? {
        guard let lifetime = LifetimeAccessor.account(id: accountLifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(accountLifetimeId: accountLifetimeId,
                     navigationLifecycle: lifetime.navigationLifecycle)
    }
}

extension RootTransitionViewFactory {
    static func makeAccountEditTransitionPresenter(
        accountEditLifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionPresenter? {
        guard let accountEditLifetime = LifetimeAccessor.accountEdit(id: accountEditLifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(accountEditLifetimeId: accountEditLifetimeId,
                     accountEditInteractor: accountEditLifetime.interactor)
    }

    static func makeAccountEditTransitionModalPresenter(
        accountEditLifetimeId: AccountEditLifetimeId
    ) -> AccountEditTransitionModalPresenter? {
        guard let accountEditLifetime = LifetimeAccessor.accountEdit(id: accountEditLifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(sourcePublisher: accountEditLifetime.modalLifecycle.$current)
    }
}

// MARK: -

extension RootTransitionViewFactory {
    static func makeLoginFailedAlertPresenter(
        lifetimeId: RootAlertLifetimeId
    ) -> RootLoginFailedAlertPresenter? {
        guard let lifetime = LifetimeAccessor.rootAlert(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(interactor: lifetime.interactor)
    }
}
