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
    static let appLifecycle: AppLifecycle = .init(factory: AppFactory.self)

    static var app: AppLifetime? {
        guard let lifetime = self.appLifecycle.lifetime else {
            preconditionFailure()
        }
        return lifetime
    }

    static func scene(id: SceneLifetimeId) -> SceneLifetime? {
        guard let lifetime = self.app?.sceneLifecycle.lifetime(id: id) else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func launch(sceneId: SceneLifetimeId) -> LaunchLifetime? {
        guard case .launch(let lifetime) = self.scene(id: sceneId)?.rootLifecycle.current else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func login(sceneId: SceneLifetimeId) -> LoginLifetime? {
        guard case .login(let lifetime) = self.scene(id: sceneId)?.rootLifecycle.current else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func account(id: AccountLifetimeId) -> AccountLifetime? {
        guard case .account(let lifetime) = self.scene(id: id.scene)?.rootLifecycle.current,
           lifetime.lifetimeId == id else {
            // NavigationをPushした状態でログアウトするとViewが更新され呼ばれるのでAssertしない
            return nil
        }
        return lifetime
    }

    static func accountInfo(id: AccountInfoLifetimeId) -> AccountInfoLifetime? {
        guard let account = self.account(id: id.account),
              let subLifetime = account.navigationLifecycle.stack.first(where: {
                  guard case .info = $0 else { return false }
                  return true
              }),
              case .info(let lifetime) = subLifetime,
              lifetime.lifetimeId == id else {
            // NavigationをPushした状態でログアウトするとViewが更新され呼ばれるのでAssertしない
            return nil
        }
        return lifetime
    }

    static func accountDetail(id: AccountDetailLifetimeId) -> AccountDetailLifetime? {
        guard let account = self.account(id: id.account),
              let subLifetime = account.navigationLifecycle.stack.first(where: {
                  guard case .detail = $0 else { return false }
                  return true
              }),
              case .detail(let lifetime) = subLifetime,
              lifetime.lifetimeId == id else {
            // NavigationをPushした状態でログアウトするとViewが更新され呼ばれるのでAssertしない
            return nil
        }
        return lifetime
    }

    static func accountEdit(id: AccountEditLifetimeId) -> AccountEditLifetime? {
        guard case .accountEdit(let lifetime) =
                self.scene(id: id.account.scene)?.rootModalLifecycle.current,
              lifetime.lifetimeId == id else {
            // AccountEditのSheetを閉じる時にViewが更新され呼ばれることがあるのでAssertしない
            return nil
        }
        return lifetime
    }

    static func rootAlert(id: RootAlertLifetimeId) -> RootAlertLifetime? {
        guard case .alert(let lifetime) =
                self.scene(id: id.scene)?.rootModalLifecycle.current,
              lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }

    static func accountEditAlert(id: AccountEditAlertLifetimeId) -> AccountEditAlertLifetime? {
        guard case .alert(let lifetime) =
                self.accountEdit(id: id.accountEdit)?.modalLifecycle.current,
              lifetime.lifetimeId == id else {
            assertionFailure()
            return nil
        }
        return lifetime
    }
}
