//
//  LogoutInteractor.swift
//

/**
 ログアウト処理
 */

@MainActor
final class LogoutInteractor {
    private let accountId: Int
    private unowned var rootLifecycle: (any RootLifecycleForLogoutInteractor)?
    private unowned var accountRepository: (any AccountRepositoryForLogoutInteractor)?

    init(accountId: Int,
         rootLifecycle: any RootLifecycleForLogoutInteractor,
         accountRepository: any AccountRepositoryForLogoutInteractor) {
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
