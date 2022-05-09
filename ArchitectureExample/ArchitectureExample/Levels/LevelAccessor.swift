//
//  LevelAccessor.swift
//

@MainActor
enum LevelAccessor: LevelAccessable {
    static let appRouter: AppLevelRouter<LevelAccessor> = .init()
    
    static var app: AppLevel<LevelAccessor>? {
        guard let level = self.appRouter.level else {
            preconditionFailure()
        }
        return level
    }
    
    static func scene(id: SceneLevelId) -> SceneLevel<LevelAccessor>? {
        guard let level = self.app?.sceneRouter.level(id: id) else {
            assertionFailure()
            return nil
        }
        return level
    }
    
    static func launch(sceneId: SceneLevelId) -> LaunchLevel? {
        guard case .launch(let level) = self.scene(id: sceneId)?.rootRouter.current else {
            assertionFailure()
            return nil
        }
        return level
    }
    
    static func login(sceneId: SceneLevelId) -> LoginLevel? {
        guard case .login(let level) = self.scene(id: sceneId)?.rootRouter.current else {
            assertionFailure()
            return nil
        }
        return level
    }
    
    static func account(id: AccountLevelId) -> AccountLevel? {
        guard case .account(let level) = self.scene(id: id.sceneLevelId)?.rootRouter.current,
           level.accountInteractor.id == id.accountId else {
            assertionFailure()
            return nil
        }
        return level
    }
    
    static func accountMenu(id: AccountLevelId) -> AccountMenuLevel? {
        guard let account = self.account(id: id),
              let subLevel = account.navigationRouter.levels.first(where: {
                  guard case .menu = $0 else { return false }
                  return true
              }),
              case .menu(let level) = subLevel else {
            assertionFailure()
            return nil
        }
        return level
    }
    
    static func accountInfo(id: AccountLevelId) -> AccountInfoLevel? {
        guard let account = self.account(id: id),
              let subLevel = account.navigationRouter.levels.first(where: {
                  guard case .info = $0 else { return false }
                  return true
              }),
              case .info(let level) = subLevel else {
            assertionFailure()
            return nil
        }
        return level
    }
    
    static func accountEdit(id: AccountLevelId) -> AccountEditLevel? {
        guard case .accountEdit(let level) = self.scene(id: id.sceneLevelId)?.rootModalRouter.current,
              level.interactor.accountLevelId == id else {
            assertionFailure()
            return nil
        }
        return level
    }
}
