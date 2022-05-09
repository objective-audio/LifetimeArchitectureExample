//
//  RootModalLevelRouter.swift
//

@MainActor
final class RootModalLevelRouter<Accessor: LevelAccessable> {
    private let sceneLevelId: SceneLevelId
    
    @CurrentValue private(set) var current: RootModalSubLevel? = nil
    
    init(sceneLevelId: SceneLevelId) {
        self.sceneLevelId = sceneLevelId
    }
    
    func showAlert(content: RootAlertContent) {
        guard self.current == nil else {
            assertionFailureIfNotTest()
            return
        }
        
        self.current = .alert(.init(content: content))
    }
    
    func hideAlert(id: RootAlertContent) {
        guard case .alert(let level) = self.current,
              level.content == id else {
            assertionFailureIfNotTest()
            return
        }
        
        self.current = nil
    }
    
    func showAccountEdit(accountLevelId: AccountLevelId) {
        guard self.current == nil else {
            assertionFailureIfNotTest()
            return
        }
        
        let level = AccountEditLevel(accountLevelId: accountLevelId,
                                     accessor: Accessor.self)
        self.current = .accountEdit(level)
    }
    
    func hideAccountEdit(accountLevelId: AccountLevelId) {
        guard case .accountEdit(let level) = self.current,
              level.interactor.accountLevelId == accountLevelId else {
            assertionFailureIfNotTest()
            return
        }
        
        self.current = nil
    }
}
