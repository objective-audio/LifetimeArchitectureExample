//
//  RootChild.swift
//

enum RootChild: Equatable {
    case login(lifetimeId: SceneLifetimeId)
    case account(lifetimeId: AccountLifetimeId)
}
