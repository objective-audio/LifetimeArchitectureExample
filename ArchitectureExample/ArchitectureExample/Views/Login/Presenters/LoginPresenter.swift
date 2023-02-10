//
//  LoginPresenter.swift
//

import Foundation

@MainActor
final class LoginPresenter {
    private weak var interactor: LoginInteractorForPresenter?

    @Published private var isLoginEnabled: Bool = false
    @Published private var isTextEditingEnabled: Bool = false
    @Published private var isConnecting: Bool = false

    init(interactor: LoginInteractorForPresenter?) {
        self.interactor = interactor

        guard let interactor = interactor else { return }

        interactor.isValidPublisher
            .combineLatest(interactor.isConnectingPublisher,
                           interactor.canOperatePublisher)
            .map { $0 && !$1 && $2 }
            .removeDuplicates()
            .assign(to: &$isLoginEnabled)

        interactor.isConnectingPublisher
            .combineLatest(interactor.canOperatePublisher)
            .map { !$0 && $1 }
            .removeDuplicates()
            .assign(to: &$isTextEditingEnabled)

        interactor.isConnectingPublisher
            .removeDuplicates()
            .assign(to: &$isConnecting)
    }

    var accountId: String {
        get { self.interactor?.accountId ?? "" }
        set { self.interactor?.accountId = newValue }
    }

    var isTextFieldDisabled: Bool { !self.isTextEditingEnabled }
    var isActivityIndicatorEnabled: Bool { self.isConnecting }
    var isLoginButtonDisabled: Bool { !self.isLoginEnabled }
    var isCancelButtonEnabled: Bool { self.isConnecting }

    func login() {
        self.interactor?.login()
    }

    func cancel() {
        self.interactor?.cancel()
    }
}
