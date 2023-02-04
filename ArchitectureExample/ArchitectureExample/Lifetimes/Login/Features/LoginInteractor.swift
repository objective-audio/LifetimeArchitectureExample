//
//  LoginInteractor.swift
//

import Combine

/**
 ログイン画面の処理
 */

@MainActor
final class LoginInteractor {
    private let sceneLifetimeId: SceneLifetimeId
    private unowned let rootLifecycle: RootLifecycleForLoginInteractor
    private unowned let rootModalLifecycle: RootModalLifecycleForLoginInteractor
    private unowned let accountRepository: AccountRepositoryForLoginInteractor
    private unowned let network: LoginNetworkForLoginInteractor

    @CurrentValue var accountId: String = ""
    @CurrentValue private var task: Task<Void, Never>?

    @CurrentValue private(set) var isValid: Bool = false
    @CurrentValue private(set) var isConnecting: Bool = false
    @CurrentValue private(set) var canOperate: Bool = false

    private var cancellables: Set<AnyCancellable> = .init()

    init(sceneLifetimeId: SceneLifetimeId,
         rootLifecycle: RootLifecycleForLoginInteractor,
         rootModalLifecycle: RootModalLifecycleForLoginInteractor,
         accountRepository: AccountRepositoryForLoginInteractor,
         network: LoginNetworkForLoginInteractor) {
        self.sceneLifetimeId = sceneLifetimeId
        self.rootLifecycle = rootLifecycle
        self.rootModalLifecycle = rootModalLifecycle
        self.accountRepository = accountRepository
        self.network = network

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

        rootLifecycle.isLoginPublisher
            .combineLatest(rootModalLifecycle.hasCurrentPublisher)
            .map { $0 && !$1 }
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
        guard self.isValid else {
            return
        }

        guard !self.isConnecting, self.canOperate else {
            assertionFailureIfNotTest()
            return
        }

        let accountId = self.accountId

        self.task = Task { [weak self] in
            guard let result = await self?.network.getAccount(id: accountId) else {
                assertionFailureIfNotTest()
                return
            }

            if let self = self {
                self.task = nil

                guard !Task.isCancelled else {
                    self.showLoginFailedAlert(.cancelled)
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
                    guard !self.accountRepository.accounts.contains(where: { $0.id == account.id }) else {
                        self.showLoginFailedAlert(.accountDuplicated)
                        return
                    }

                    self.accountRepository.append(account: account)
                    self.rootLifecycle.switchToAccount(account: account)
                }
            }
        }
    }

    func cancel() {
        self.task?.cancel()
    }
}

private extension LoginInteractor {
    func showLoginFailedAlert(_ kind: RootAlertId.LoginFailedKind) {
        self.rootModalLifecycle.addAlert(id: .loginFailed(kind))
    }
}
