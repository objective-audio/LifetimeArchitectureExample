//
//  AccountDetailInteractorDependencies.swift
//  ArchitectureExample
//
//  Created by Yuki Yasoshima on 2023/01/24.
//

import Foundation

protocol AccountNavigationLifecycleForAccountDetailInteractor: AnyObject {
    func canPopDetail(lifetimeId: AccountDetailLifetimeId) -> Bool
    func popDetail(lifetimeId: AccountDetailLifetimeId)
}
