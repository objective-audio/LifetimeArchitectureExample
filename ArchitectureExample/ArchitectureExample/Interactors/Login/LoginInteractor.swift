//
//  LoginInteractor.swift
//

import Combine

@MainActor
final class LoginInteractor {
    private let sceneLevelId: SceneLevelId
    private weak var rootLevelRouter: RootLevelRouterForLogin?
    private weak var rootModalLevelRouter: RootModalLevelRouterForLogin?
    private weak var accountRepository: AccountRepositoryForLogin?
    private unowned let loginNetwork: LoginNetworkForLogin
    
    @CurrentValue var accountId: String = ""
    @CurrentValue private var task: Task<Void, Never>? = nil
    
    @CurrentValue private(set) var isValid: Bool = false
    @CurrentValue private(set) var isConnecting: Bool = false
    @CurrentValue private(set) var canOperate: Bool = false
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(sceneLevelId: SceneLevelId,
         rootLevelRouter: RootLevelRouterForLogin?,
         rootModalLevelRouter: RootModalLevelRouterForLogin?,
         accountRepository: AccountRepositoryForLogin?,
         network: LoginNetworkForLogin) {
        self.sceneLevelId = sceneLevelId
        self.rootLevelRouter = rootLevelRouter
        self.rootModalLevelRouter = rootModalLevelRouter
        self.accountRepository = accountRepository
        self.loginNetwork = network
        
        self.$accountId
            .map { !$0.isEmpty }
            .assign(to: \.value,
                    on: self.$isValid)
            .store(in: &self.cancellables)
        
        self.$task
            .map { $0 != nil }
            .assign(to: \.value,
                    on: self.$isConnecting)
            .store(in: &self.cancellables)
        
        rootLevelRouter?.isLoginPublisher
            .assign(to: \.value,
                    on: self.$canOperate)
            .store(in: &self.cancellables)
    }
    
    var isValidPublisher: AnyPublisher<Bool, Never> {
        self.$isValid.removeDuplicates().eraseToAnyPublisher()
    }
    
    var isConnectingPublisher: AnyPublisher<Bool, Never> {
        self.$isConnecting.removeDuplicates().eraseToAnyPublisher()
    }
    
    var canOperatePublisher: AnyPublisher<Bool, Never> {
        self.$canOperate.removeDuplicates().eraseToAnyPublisher()
    }
    
    func login() {
        guard self.isValid, !self.isConnecting, self.canOperate else {
            assertionFailureIfNotTest()
            return
        }
        
        let accountId = self.accountId
        
        self.task = Task { [weak self] in
            guard let result = await self?.loginNetwork.getAccount(id: accountId) else {
                assertionFailureIfNotTest()
                return
            }
            
            if let self = self {
                self.task = nil
                
                guard !Task.isCancelled else {
                    self.showLoginFailedAlert(.cancelled)
                    return
                }
                
                guard let repository = self.accountRepository,
                      let rootRouter = self.rootLevelRouter else {
                    self.showLoginFailedAlert(.other)
                    return
                }
                
                switch result {
                case .failure(let error):
                    switch error {
                    case .cancelled:
                        self.showLoginFailedAlert(.cancelled)
                    case .invalidAccountID:
                        self.showLoginFailedAlert(.invalidAccountID)
                    }
                case .success(let account):
                    guard !repository.accounts.contains(where: { $0.id == account.id }) else {
                        self.showLoginFailedAlert(.accountDuplicated)
                        return
                    }
                    
                    repository.append(account: account)
                    rootRouter.switchToAccount(account: account)
                }
            }
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
}

private extension LoginInteractor {
    func showLoginFailedAlert(_ kind: RootAlertContent.LoginFailedKind) {
        self.rootModalLevelRouter?.showAlert(content: .loginFailed(kind))
    }
}
