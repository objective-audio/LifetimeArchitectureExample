//
//  AccountInfoInteractor.swift
//

import Combine

/**
 アカウント情報画面の処理
 */

@MainActor
final class AccountInfoInteractor {
    typealias AccountHolder = AccountHolderForAccountInfoInteractor
    typealias NavigationLifecycle = AccountNavigationLifecycleForAccountInfoInteractor
    typealias RootModalLifecycle = RootModalLifecycleForAccountInfoInteractor

    let uiSystem: UISystem
    private let lifetimeId: AccountInfoLifetimeId

    private weak var accountHolder: AccountHolder!
    private weak var navigationLifecycle: NavigationLifecycle?
    private weak var rootModalLifecycle: RootModalLifecycle!

    init(uiSystem: UISystem,
         lifetimeId: AccountInfoLifetimeId,
         accountHolder: AccountHolder?,
         navigationLifecycle: NavigationLifecycle?,
         rootModalLifecycle: RootModalLifecycle?) {
        self.uiSystem = uiSystem
        self.lifetimeId = lifetimeId
        self.accountHolder = accountHolder
        self.navigationLifecycle = navigationLifecycle
        self.rootModalLifecycle = rootModalLifecycle
    }

    var accountId: Int { self.lifetimeId.account.accountId }

    var namePublisher: AnyPublisher<String, Never> {
        self.accountHolder.namePublisher
    }

    func editAccount() {
        self.rootModalLifecycle
            .addAccountEdit(accountLifetimeId: self.lifetimeId.account)
    }

    func finalize() {
        self.navigationLifecycle?.popInfo(lifetimeId: self.lifetimeId)

        self.navigationLifecycle = nil
    }
}
