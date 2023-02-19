//
//  LifetimeIds.swift
//

import Foundation

/// SceneLifetimeのスコープを特定するID

struct SceneLifetimeId: Hashable {
    let uuid: UUID
}

/// RootAlertLifetimeのスコープを特定するためのID

struct RootAlertLifetimeId: Hashable {
    let instanceId: InstanceId
    let scene: SceneLifetimeId
}

/// AccountLifetimeのスコープを特定するためのID

struct AccountLifetimeId: Hashable {
    let scene: SceneLifetimeId
    let accountId: Int
}

/**
 AccountLifeitmeの子のスコープを特定するためのID
 基本的にtypealiasで別名をつけて使う
 */

struct AccountSubLifetimeId: Hashable {
    let instanceId: InstanceId
    let account: AccountLifetimeId
}

/// AccountEditLifetimeのスコープを特定するためのID
typealias AccountEditLifetimeId = AccountSubLifetimeId
/// AccountInfoLifetimeのスコープを特定するためのID
typealias AccountInfoLifetimeId = AccountSubLifetimeId
/// AccountDetailLifetimeのスコープを特定するためのID
typealias AccountDetailLifetimeId = AccountSubLifetimeId

/// AccountEditAlertLifetimeのスコープを特定するためのID

struct AccountEditAlertLifetimeId: Hashable {
    let instanceId: InstanceId
    let accountEdit: AccountEditLifetimeId
}
