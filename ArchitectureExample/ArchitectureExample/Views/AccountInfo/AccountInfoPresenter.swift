//
//  AccountInfoPresenter.swift
//

import Foundation

@MainActor
final class AccountInfoPresenter {
    private let accountLevelId: AccountLevelId
    
    private weak var accountInteractor: AccountInteractor?
    private weak var navigationRouter: AccountNavigationLevelRouter?
    private weak var modalRouter: RootModalLevelRouter<LevelAccessor>?
    
    @Published private var name: String = ""
    
    init(accountLevelId: AccountLevelId,
         accountInteractor: AccountInteractor,
         navigationRouter: AccountNavigationLevelRouter,
         modalRouter: RootModalLevelRouter<LevelAccessor>) {
        self.accountLevelId = accountLevelId
        self.accountInteractor = accountInteractor
        self.navigationRouter = navigationRouter
        self.modalRouter = modalRouter
        
        accountInteractor.namePublisher.assign(to: &$name)
    }
    
    var sections: [[AccountInfoContent]] {
        return [[.id(self.accountLevelId.accountId), .name(self.name)],
                [.edit]]
    }
    
    func viewDidDismiss() {
        self.navigationRouter?.popInfo()
    }
    
    func handle(action: AccountInfoAction) {
        switch action {
        case .edit:
            self.modalRouter?.showAccountEdit(accountLevelId: self.accountLevelId)
        }
    }
    
    func didSelect(at indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        guard section < self.sections.count,
              row < self.sections[section].count else {
            return
        }
        
        let content = self.sections[section][row]
        
        content.action.flatMap { self.handle(action:$0) }
    }
}
