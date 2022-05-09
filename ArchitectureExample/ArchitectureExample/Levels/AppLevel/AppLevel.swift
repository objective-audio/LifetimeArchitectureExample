//
//  AppLevel.swift
//

import Foundation

struct AppLevel<Accessor: LevelAccessable> {
    let sceneRouter: SceneLevelRouter<Accessor>
    let userDefaults: UserDefaults
    let accountRepository: AccountRepository
}
