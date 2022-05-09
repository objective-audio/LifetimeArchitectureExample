//
//  AccountMenuViewDependencies.swift
//

import Foundation

protocol PresenterForAccountMenuView: ObservableObject {
    var sections: [AccountMenuSection] { get }
    var title: String { get }
    
    func didSelect(content: AccountMenuContent)
}
