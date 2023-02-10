//
//  AccountNavigationViewFactory.swift
//

// MARK: -

@MainActor
enum AccountNavigationViewFactory {}

// MARK: -

extension AccountMenuPresenter: PresenterForAccountMenuView {}
extension AccountInfoSwiftUIPresenter: PresenterForAccountInfoView {}

extension AccountNavigationViewFactory: FactoryForAccountNavigationView {
    static func makeAccountMenuPresenter(lifetimeId: AccountLifetimeId) -> AccountMenuPresenter? {
        guard let accountLifetime = LifetimeAccessor.account(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(accountHolder: accountLifetime.accountHolder,
                     interactor: accountLifetime.accountMenuInteractor)
    }

    static func makeAccountInfoSwiftUIPresenter(
        lifetimeId: AccountInfoLifetimeId
    ) -> AccountInfoSwiftUIPresenter? {
        guard let accountInfoLifetime = LifetimeAccessor.accountInfo(id: lifetimeId),
              accountInfoLifetime.interactor.uiSystem == .swiftUI else {
            assertionFailure()
            return nil
        }

        return .init(interactor: accountInfoLifetime.interactor)
    }

    static func makeAccountInfoUIKitPresenter(
        lifetimeId: AccountInfoLifetimeId
    ) -> AccountInfoUIKitPresenter? {
        guard let accountInfoLifetime = LifetimeAccessor.accountInfo(id: lifetimeId),
              accountInfoLifetime.interactor.uiSystem == .uiKit else {
            assertionFailure()
            return nil
        }

        return .init(interactor: accountInfoLifetime.interactor)
    }

    static func makeAccountDetailPresenter(
        lifetimeId: AccountDetailLifetimeId
    ) -> AccountDetailPresenter? {
        guard let accountDetailLifetime = LifetimeAccessor.accountDetail(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        return .init(interactor: accountDetailLifetime.interactor)
    }
}
