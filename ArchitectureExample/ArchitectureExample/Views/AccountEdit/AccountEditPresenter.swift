//
//  AccountEditPresenter.swift
//

import Combine

@MainActor
final class AccountEditPresenter {
    let accountLevelId: AccountLevelId
    
    private weak var interactor: AccountEditInteractor?
    
    @Published var isSaveButtonDisabled: Bool = true
    
    var name: String {
        get { self.interactor?.name ?? "" }
        set { self.interactor?.name = newValue }
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(accountLevelId: AccountLevelId,
         interactor: AccountEditInteractor) {
        self.accountLevelId = accountLevelId
        self.interactor = interactor
        
        interactor.$isEdited
            .map { !$0 }
            .assign(to: &$isSaveButtonDisabled)
    }
    
    func commit() {
        self.interactor?.save()
    }
    
    func cancel() {
        self.interactor?.cancel()
    }
}
