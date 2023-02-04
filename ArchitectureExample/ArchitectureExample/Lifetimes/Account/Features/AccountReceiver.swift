//
//  AccountReceiver.swift
//

final class AccountReceiver: ActionReceivable {
    private let accountLifetimeId: AccountLifetimeId
    private unowned let logoutInteractor: LogoutInteractorForAccountReceiver
    private unowned let rootModalLifecycle: RootModalLifecycleForAccountReceiver

    init(accountLifetimeId: AccountLifetimeId,
         logoutInteractor: LogoutInteractorForAccountReceiver,
         rootModalLifecycle: RootModalLifecycleForAccountReceiver) {
        self.accountLifetimeId = accountLifetimeId
        self.logoutInteractor = logoutInteractor
        self.rootModalLifecycle = rootModalLifecycle
        self.receivableId = .init(accountLifetimeId: accountLifetimeId)
    }

    let receivableId: ActionId?

    func receive(_ action: Action) -> ActionContinuation {
        switch action.kind {
        case .logout:
            // ここまで辿り着いたらログアウトして良い
            self.logoutInteractor.logout()
            // ログアウトを実行したので終了
            return .break
        case .reopenEdit:
            // ここまで辿り着いたらアカウント編集画面を開く
            self.rootModalLifecycle.addAccountEdit(accountLifetimeId: self.accountLifetimeId)
            return .break
        }
    }
}
