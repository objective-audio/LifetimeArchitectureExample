//
//  AccountEditAlertLifetime.swift
//

/**
 アカウント編集画面のアラートの生存期間で必要な機能を保持する
 */

struct AccountEditAlertLifetime {
    let lifetimeId: AccountEditAlertLifetimeId
    let alertId: AccountEditAlertId
    let interactor: AccountEditAlertInteractor
    let receiver: AccountEditAlertReceiver
}
