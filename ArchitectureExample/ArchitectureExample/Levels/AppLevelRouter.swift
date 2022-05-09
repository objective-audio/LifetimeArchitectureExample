//
//  AppLevelRouter.swift
//

@MainActor
final class AppLevelRouter<Accessor: LevelAccessable> {
    @CurrentValue private(set) var level: AppLevel<Accessor>? = nil
    
    func addLevel() {
        guard self.level == nil else {
            assertionFailureIfNotTest()
            return
        }
        
        self.level = .init()
    }
}
