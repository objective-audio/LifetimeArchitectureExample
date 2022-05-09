//
//  AccountInfoViewDependencies.swift
//

import Foundation

protocol PresenterForAccountInfoView: ObservableObject {
    var sections: [[AccountInfoContent]] { get }
    
    func handle(action: AccountInfoAction)
}
