//
//  LogoutInteractor.swift
//

/**
 ログアウト処理
 */

@MainActor
final class LogoutInteractor {
    typealias RootLifecycle = RootLifecycleForLogoutInteractor
    typealias AccountRepository = AccountRepositoryForLogoutInteractor

    private let accountId: Int
    private unowned var rootLifecycle: RootLifecycle?
    private unowned var accountRepository: AccountRepository?

    init(accountId: Int,
         rootLifecycle: RootLifecycle,
         accountRepository: AccountRepository) {
        self.accountId = accountId
        self.rootLifecycle = rootLifecycle
        self.accountRepository = accountRepository
    }

    func logout() {
        guard let repository = self.accountRepository,
              let lifecycle = self.rootLifecycle else {
            assertionFailureIfNotTest()
            return
        }

        repository.remove(accountId: self.accountId)
        lifecycle.switchToLogin()

        self.accountRepository = nil
        self.rootLifecycle = nil
    }
}
