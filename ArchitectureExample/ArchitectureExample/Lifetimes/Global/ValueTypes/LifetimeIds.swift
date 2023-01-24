//
//  LifetimeIds.swift
//

/// SceneLifetimeのスコープを特定するID

struct SceneLifetimeId: Equatable {
    let instanceId: InstanceId
}

/// RootAlertLifetimeのスコープを特定するためのID

struct RootAlertLifetimeId: Equatable {
    let instanceId: InstanceId
    let scene: SceneLifetimeId
}

/// AccountLifetimeのスコープを特定するためのID

struct AccountLifetimeId: Equatable {
    let scene: SceneLifetimeId
    let accountId: Int
}

/**
 AccountLifeitmeの子のスコープを特定するためのID
 基本的にtypealiasで別名をつけて使う
 */

struct AccountSubLifetimeId: Equatable {
    let instanceId: InstanceId
    let account: AccountLifetimeId
}

/// AccountEditLifetimeのスコープを特定するためのID
typealias AccountEditLifetimeId = AccountSubLifetimeId
/// AccountMenuLifetimeのスコープを特定するためのID
typealias AccountMenuLifetimeId = AccountSubLifetimeId
/// AccountInfoLifetimeのスコープを特定するためのID
typealias AccountInfoLifetimeId = AccountSubLifetimeId
/// AccountDetailLifetimeのスコープを特定するためのID
typealias AccountDetailLifetimeId = AccountSubLifetimeId

/// AccountEditAlertLifetimeのスコープを特定するためのID

struct AccountEditAlertLifetimeId: Equatable {
    let instanceId: InstanceId
    let accountEdit: AccountEditLifetimeId
}
