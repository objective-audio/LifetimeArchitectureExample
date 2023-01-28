//
//  LifetimeAccessor.swift
//

extension AppFactory: FactoryForAppLifecycle {}

/**
 アプリ本体でLifetimeを取得する
 基本的にFactoryからのみ呼んで良い
 */

@MainActor
enum LifetimeAccessor {
    static let appLifecycle: AppLifecycle<AppFactory> = .init()

    static var app: AppLifetimeForLifecycle? {
        guard let lifetime = self.appLifecycle.lifetime else {
            preconditionFailure()
        }
        return lifetime
    }

    static func scene(id: SceneLifetimeId) -> SceneLifetimeForLifecycle? {
        guard let lifetime = self.app?.sceneLifecycle.lifetime(id: id) else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func launch(sceneId: SceneLifetimeId) -> LaunchLifetimeForLifecycle? {
        guard case .launch(let lifetime) = self.scene(id: sceneId)?.rootLifecycle.current else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func login(sceneId: SceneLifetimeId) -> LoginLifetimeForLifecycle? {
        guard case .login(let lifetime) = self.scene(id: sceneId)?.rootLifecycle.current else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func account(id: AccountLifetimeId) -> AccountLifetimeForLifecycle? {
        guard case .account(let lifetime) = self.scene(id: id.scene)?.rootLifecycle.current,
           lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func accountMenu(id: AccountMenuLifetimeId) -> AccountMenuLifetimeForLifecycle? {
        guard let account = self.account(id: id.account),
              let subLifetime = account.navigationLifecycle.stack.first(where: {
                  guard case .menu = $0 else { return false }
                  return true
              }),
              case .menu(let lifetime) = subLifetime,
              lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func accountInfo(id: AccountInfoLifetimeId) -> AccountInfoLifetimeForLifecycle? {
        guard let account = self.account(id: id.account),
              let subLifetime = account.navigationLifecycle.stack.first(where: {
                  guard case .info = $0 else { return false }
                  return true
              }),
              case .info(let lifetime) = subLifetime,
              lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func accountDetail(id: AccountDetailLifetimeId) -> AccountDetailLifetimeForLifecycle? {
        guard let account = self.account(id: id.account),
              let subLifetime = account.navigationLifecycle.stack.first(where: {
                  guard case .detail = $0 else { return false }
                  return true
              }),
              case .detail(let lifetime) = subLifetime,
              lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func accountEdit(id: AccountEditLifetimeId) -> AccountEditLifetimeForLifecycle? {
        guard case .accountEdit(let lifetime) =
                self.scene(id: id.account.scene)?.rootModalLifecycle.current,
              lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func rootAlert(id: RootAlertLifetimeId) -> RootAlertLifetimeForLifecycle? {
        guard case .alert(let lifetime) =
                self.scene(id: id.scene)?.rootModalLifecycle.current,
              lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func accountEditAlert(id: AccountEditAlertLifetimeId) -> AccountEditAlertLifetimeForLifecycle? {
        guard case .alert(let lifetime) =
                self.accountEdit(id: id.accountEdit)?.modalLifecycle.current,
              lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }
}
