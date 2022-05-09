//
//  AppPresenter.swift
//

final class AppPresenter {
    private weak var appLevelRouter: AppLevelRouter<LevelAccessor>?
    
    init(appLevelRouter: AppLevelRouter<LevelAccessor>) {
        self.appLevelRouter = appLevelRouter
    }
    
    @MainActor
    func didFinishLaunching() {
        self.appLevelRouter?.addLevel()
    }
}
