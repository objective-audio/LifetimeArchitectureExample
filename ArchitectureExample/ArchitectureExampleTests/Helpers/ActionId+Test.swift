//
//  ActionId+Test.swift
//

import Foundation
@testable import ArchitectureExample

 extension GlobalActionId: Equatable {
    public static func == (lhs: GlobalActionId, rhs: GlobalActionId) -> Bool {
        lhs.sceneLifetimeId == rhs.sceneLifetimeId && lhs.accountId == rhs.accountId
    }
 }
