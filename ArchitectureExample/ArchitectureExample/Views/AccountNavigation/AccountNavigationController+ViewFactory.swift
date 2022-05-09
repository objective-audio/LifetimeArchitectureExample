//
//  AccountNavigationController+Factory.swift
//

// MARK: -

extension AccountMenuPresenter: AccountMenuView.Presenter {}

extension AccountNavigationController {
    static func makeAccountMenuHostingController(
        lifetimeId: AccountMenuLifetimeId
    ) -> AccountMenuHostingController? {
        guard let accountLifetime = LifetimeAccessor.account(id: lifetimeId.account),
              let accountMenuLifetime = LifetimeAccessor.accountMenu(id: lifetimeId) else {
            assertionFailure()
            return nil
        }

        let presenter = AccountMenuPresenter(accountHolder: accountLifetime.accountHolder,
                                             interactor: accountMenuLifetime.interactor)

        return .init(presenter: presenter)
    }
}

// MARK: -

extension AccountInfoSwiftUIPresenter: AccountInfoView.Presenter {}

extension AccountNavigationController {
    static func makeAccountInfoHostingController(
        lifetimeId: AccountInfoLifetimeId
    ) -> AccountInfoHostingController? {
        guard let accountInfoLifetime = LifetimeAccessor.accountInfo(id: lifetimeId),
              accountInfoLifetime.interactor.uiSystem == .swiftUI else {
            assertionFailure()
            return nil
        }

        let presenter = AccountInfoSwiftUIPresenter(interactor: accountInfoLifetime.interactor)

        return .init(presenter: presenter)
    }
}

// MARK: -

extension AccountNavigationController {
    static func makeAccountInfoViewController(
        lifetimeId: AccountInfoLifetimeId
    ) -> AccountInfoViewController? {
        guard let accountInfoLifetime = LifetimeAccessor.accountInfo(id: lifetimeId),
              accountInfoLifetime.interactor.uiSystem == .uiKit else {
            assertionFailure()
            return nil
        }

        let presenter = AccountInfoUIKitPresenter(interactor: accountInfoLifetime.interactor)

        return AccountInfoViewController.instantiate(presenter: presenter)
    }
}
