//
//  AccountReceiver.swift
//

final class AccountReceiver<Factory: FactoryForRootModalLifecycle>: ActionReceivable {
    typealias LogoutInteractor = LogoutInteractorForAccountReceiver

    private let accountLifetimeId: AccountLifetimeId
    private unowned let logoutInteractor: LogoutInteractor
    private unowned let rootModalLifecycle: RootModalLifecycle<Factory>

    init(accountLifetimeId: AccountLifetimeId,
         logoutInteractor: LogoutInteractor,
         rootModalLifecycle: RootModalLifecycle<Factory>) {
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
