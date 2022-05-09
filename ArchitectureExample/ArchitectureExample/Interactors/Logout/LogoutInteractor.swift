//
//  LogoutInteractor.swift
//

@MainActor
final class LogoutInteractor {
    private let accountId: Int
    private weak var rootLevelRouter: RootLevelRouterForLogout?
    private weak var accountRepository: AccountRepositoryForLogout?
    
    init(accountId: Int,
         rootLevelRouter: RootLevelRouterForLogout?,
         accountRepository: AccountRepositoryForLogout?) {
        self.accountId = accountId
        self.rootLevelRouter = rootLevelRouter
        self.accountRepository = accountRepository
    }
    
    func logout() {
        guard let repository = self.accountRepository,
              let router = self.rootLevelRouter else {
            assertionFailureIfNotTest()
            return
        }
        
        repository.remove(accountId: self.accountId)
        router.switchToLogin()
        
        self.accountRepository = nil
        self.rootLevelRouter = nil
    }
}
