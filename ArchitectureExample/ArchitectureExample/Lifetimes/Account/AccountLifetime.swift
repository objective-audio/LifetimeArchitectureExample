//
//  AccountLifetime.swift
//

/**
 アカウント画面の生存期間で必要な機能を保持する
 */

struct AccountLifetime<Accessor: LifetimeAccessable> {
    let lifetimeId: AccountLifetimeId
    let accountHolder: AccountHolder
    let logoutInteractor: LogoutInteractor
    let navigationLifecycle: AccountNavigationLifecycle<Accessor>
    let receiver: AccountReceiver<Accessor>
}
