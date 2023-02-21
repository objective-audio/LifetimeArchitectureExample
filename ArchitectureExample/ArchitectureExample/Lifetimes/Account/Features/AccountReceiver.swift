//
//  AccountReceiver.swift
//

final class AccountReceiver: GlobalActionReceivable {
    private let accountLifetimeId: AccountLifetimeId
    private unowned let logoutInteractor: any LogoutInteractorForAccountReceiver
    private unowned let rootModalLifecycle: any RootModalLifecycleForAccountReceiver

    init(accountLifetimeId: AccountLifetimeId,
         logoutInteractor: any LogoutInteractorForAccountReceiver,
         rootModalLifecycle: any RootModalLifecycleForAccountReceiver) {
        self.accountLifetimeId = accountLifetimeId
        self.logoutInteractor = logoutInteractor
        self.rootModalLifecycle = rootModalLifecycle
        self.receivableId = .init(accountLifetimeId: accountLifetimeId)
    }

    let receivableId: GlobalActionId?

    func receive(_ action: GlobalAction) -> GlobalActionContinuation {
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
