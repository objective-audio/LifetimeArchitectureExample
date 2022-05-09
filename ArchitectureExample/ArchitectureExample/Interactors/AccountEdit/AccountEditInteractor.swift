//
//  AccountEditInteractor.swift
//

import Combine

@MainActor
final class AccountEditInteractor {
    let accountLevelId: AccountLevelId
    
    private weak var accountInteractor: AccountInteractorForAccountEdit?
    private weak var rootModalRouter: RootModalLevelRouterForAccountEdit?
    private weak var accountEditModalRouter: AccountEditModalLevelRouterForAccountEdit?
    
    @CurrentValue var name: String
    @CurrentValue private(set) var isEdited: Bool = false
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(accountLevelId: AccountLevelId,
         accountInteractor: AccountInteractorForAccountEdit?,
         rootModalRouter: RootModalLevelRouterForAccountEdit?,
         accountEditModalRouter: AccountEditModalLevelRouterForAccountEdit?) {
        self.accountLevelId = accountLevelId
        self.accountInteractor = accountInteractor
        self.rootModalRouter = rootModalRouter
        self.accountEditModalRouter = accountEditModalRouter
        self.name = accountInteractor?.name ?? ""
        
        let originalName = self.accountInteractor?.name
        self.$name
            .map { !$0.isEmpty && $0 != originalName }
            .removeDuplicates()
            .assign(to: \.value,
                    on: $isEdited)
            .store(in: &self.cancellables)
    }
    
    func save() {
        guard self.isEdited else {
            assertionFailureIfNotTest()
            return
        }
        
        self.accountInteractor?.name = self.name
        self.finalize()
    }
    
    func cancel() {
        if self.isEdited {
            self.accountEditModalRouter?.showAlert(content: .destruct)
        } else {
            self.finalize()
        }
    }
    
    func finalize() {
        self.rootModalRouter?.hideAccountEdit(accountLevelId: self.accountLevelId)
        
        self.accountInteractor = nil
        self.rootModalRouter = nil
    }
}
