//
//  AccountInfoInteractor.swift
//

import Combine

/**
 アカウント情報画面の処理
 */

@MainActor
final class AccountInfoInteractor {
    let uiSystem: UISystem
    private let lifetimeId: AccountInfoLifetimeId

    private unowned let accountHolder: AccountHolderForAccountInfoInteractor
    private unowned let navigationLifecycle: AccountNavigationLifecycleForAccountInfoInteractor
    private unowned let rootModalLifecycle: RootModalLifecycleForAccountInfoInteractor

    init(uiSystem: UISystem,
         lifetimeId: AccountInfoLifetimeId,
         accountHolder: AccountHolderForAccountInfoInteractor,
         navigationLifecycle: AccountNavigationLifecycleForAccountInfoInteractor,
         rootModalLifecycle: RootModalLifecycleForAccountInfoInteractor) {
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

    func pushDetail() {
        self.navigationLifecycle.pushDetail()
    }
}
