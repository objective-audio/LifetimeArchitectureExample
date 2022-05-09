//
//  RootAlertLifetime.swift
//

/**
 ルートの階層のアラートの生存期間のスコープで必要な機能を保持する
 */

struct RootAlertLifetime {
    let lifetimeId: RootAlertLifetimeId
    let alertId: RootAlertId
    let interactor: RootAlertInteractor
    let receiver: RootAlertReceiver
}
