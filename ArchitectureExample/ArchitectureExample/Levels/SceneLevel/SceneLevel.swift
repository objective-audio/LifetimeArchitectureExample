//
//  SceneLevel.swift
//

struct SceneLevel<Accessor: LevelAccessable> {
    let rootRouter: RootLevelRouter<Accessor>
    let rootModalRouter: RootModalLevelRouter<Accessor>
}
