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
    private unowned var modalLifecycle: RootModalLifecycleForRootAlertInteractor?

    init(lifetimeId: RootAlertLifetimeId,
         alertId: RootAlertId,
         modalLifecycle: RootModalLifecycleForRootAlertInteractor) {
        self.lifetimeId = lifetimeId
        self.alertId = alertId
        self.modalLifecycle = modalLifecycle
    }

    func doAction(_ action: RootAlertAction) {
        self.finalize()

        switch action {
        case .alertOK:
            break
        }
    }

    func finalize() {
        self.modalLifecycle?.removeAlert(lifetimeId: self.lifetimeId)

        self.modalLifecycle = nil
    }
}
