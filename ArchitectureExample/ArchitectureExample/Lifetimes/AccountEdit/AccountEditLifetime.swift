//
//  AccountEditLifetime.swift
//

/**
 アカウント編集画面の生存期間で必要な機能を保持する
 */

struct AccountEditLifetime {
    let lifetimeId: AccountEditLifetimeId
    let interactor: AccountEditInteractor
    let modalLifecycle: AccountEditModalLifecycle<AccountEditModalFactory>
    let receiver: AccountEditReceiver
}
