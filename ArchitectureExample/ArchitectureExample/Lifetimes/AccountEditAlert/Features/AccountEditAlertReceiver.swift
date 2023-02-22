//
//  AccountEditAlertReceiver.swift
//

final class AccountEditAlertReceiver: GlobalActionReceivable {
    private let accountLifetimeId: AccountLifetimeId
    private let alertId: AccountEditAlertId
    private unowned let interactor: any AccountEditAlertInteractorForAccountEditAlertReceiver

    init(accountLifetimeId: AccountLifetimeId,
         alertId: AccountEditAlertId,
         interactor: any AccountEditAlertInteractorForAccountEditAlertReceiver) {
        self.accountLifetimeId = accountLifetimeId
        self.receivableId = .init(accountLifetimeId: accountLifetimeId)
        self.alertId = alertId
        self.interactor = interactor
    }

    let receivableId: GlobalActionId?

    func receive(_ action: GlobalAction) -> GlobalActionContinuation {
        switch action.kind {
        case .logout:
            switch self.alertId {
            case .destruct:
                // 編集破棄確認アラートなので閉じて良い
                self.interactor.finalize()
                // アラートを閉じたら上の階層に処理を任せる
                return .continue
            case .logout:
                // すでにログアウトをしようとして確認中なので終了
                return .break
            }
        case .reopenEdit:
            // アカウント編集の上にモーダルが出ていて重なりすぎなのでとりあえず止めておく
            return .break
        }
    }
}
