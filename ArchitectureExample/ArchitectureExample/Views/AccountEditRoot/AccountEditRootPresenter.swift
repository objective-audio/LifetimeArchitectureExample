//
//  AccountEditRootPresenter.swift
//

import Combine

@MainActor
final class AccountEditRootPresenter {
    enum Modal: Equatable {
        case alert(content: AccountEditAlertContent)
    }
    
    let accountLevelId: AccountLevelId
    
    private weak var interactor: AccountEditInteractor?
    private weak var accountEditModalRouter: AccountEditModalLevelRouter?
    
    @CurrentValue private(set) var isModalInPresentation: Bool = false
    @CurrentValue private(set) var modal: Modal? = nil
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(accountLevelId: AccountLevelId,
         interactor: AccountEditInteractor,
         accountEditModalRouter: AccountEditModalLevelRouter) {
        self.accountLevelId = accountLevelId
        self.interactor = interactor
        self.accountEditModalRouter = accountEditModalRouter
        
        interactor.$isEdited
            .assign(to: \.value,
                    on: self.$isModalInPresentation)
            .store(in: &self.cancellables)
        
        accountEditModalRouter.$current
            .map(Modal.init)
            .assign(to: \.value,
                    on: self.$modal)
            .store(in: &self.cancellables)
    }
    
    func viewDidDismiss() {
        self.interactor?.finalize()
    }
}

extension AccountEditRootPresenter.Modal {
    init?(_ level: AccountEditModalSubLevel?) {
        switch level {
        case .alert(let content):
            self = .alert(content: content)
        case .none:
            return nil
        }
    }
}
