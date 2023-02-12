//
//  RootAlertInteractor.swift
//

/**
 ルート階層から出すアラート画面の処理
 */

@MainActor
final class RootAlertInteractor {
    let lifetimeId: RootAlertLifetimeId
    let alertId: RootAlertId

    init(lifetimeId: RootAlertLifetimeId,
         alertId: RootAlertId) {
        self.lifetimeId = lifetimeId
        self.alertId = alertId
    }
}
