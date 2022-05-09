//
//  ActionId+Test.swift
//

import Foundation
@testable import ArchitectureExample

 extension ActionId: Equatable {
    public static func == (lhs: ActionId, rhs: ActionId) -> Bool {
        lhs.sceneLifetimeId == rhs.sceneLifetimeId && lhs.accountId == rhs.accountId
    }
 }
