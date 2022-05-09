//
//  AccountNavigationLevelRouter.swift
//

@MainActor
final class AccountNavigationLevelRouter {
    @CurrentValue private(set) var levels: [AccountNavigationSubLevel] = []
    
    func pushMenu() {
        guard self.levels.isEmpty else {
            assertionFailureIfNotTest()
            return
        }
        
        self.levels.append(.menu(.init()))
    }
    
    func pushInfo(uiSystem: UISystem) {
        guard self.levels.count == 1, case .menu = self.levels[0] else {
            assertionFailureIfNotTest()
            return
        }
        
        self.levels.append(.info(.init(uiSystem: uiSystem)))
    }
    
    func popInfo() {
        guard case .info = self.levels.last else {
            assertionFailureIfNotTest()
            return
        }
        
        self.levels.removeLast()
    }
}
