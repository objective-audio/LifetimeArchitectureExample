//
//  AccountInfoViewDependencies.swift
//

import Foundation

protocol PresenterForAccountInfoView: ObservableObject {
    var contents: [[AccountInfoContent]] { get }

    func handle(action: AccountInfoAction)
}
