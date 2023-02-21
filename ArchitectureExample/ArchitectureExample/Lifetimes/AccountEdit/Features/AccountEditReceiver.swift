//
//  AccountEditReceiver.swift
//

final class AccountEditReceiver: GlobalActionReceivable {
    private let accountLifetimeId: AccountLifetimeId
    private unowned let accountEditModalLifecycle: AccountEditModalLifecycleForAccountEditReceiver
    private unowned let interactor: AccountEditInteractorForAccountEditReceiver

    init(accountLifetimeId: AccountLifetimeId,
         accountEditModalLifecycle: AccountEditModalLifecycleForAccountEditReceiver,
         interactor: AccountEditInteractorForAccountEditReceiver) {
        self.accountLifetimeId = accountLifetimeId
        self.receivableId = .init(accountLifetimeId: accountLifetimeId)
        self.accountEditModalLifecycle = accountEditModalLifecycle
        self.interactor = interactor
    }

    let receivableId: GlobalActionId?

    func receive(_ action: GlobalAction) -> GlobalActionContinuation {
        switch action.kind {
        case .logout:
            if self.interactor.isEdited {
                self.accountEditModalLifecycle.addAlert(id: .logout)
                // ログアウト確認アラートを表示したので終了
                return .break
            } else {
                // ログアウトできるのでアカウント編集のモーダルを閉じる
                self.interactor.finalize()
                // ログアウト処理は上の階層に任せる
                return .continue
            }
        case .reopenEdit:
            if self.interactor.isEdited {
                // 編集中なら中断
                return .break
            } else {
                // アカウント編集のモーダルを閉じる
                self.interactor.finalize()
                // アカウント編集のモーダルを閉じたら上の階層で開く
                return .continue
            }
        }
    }
}
