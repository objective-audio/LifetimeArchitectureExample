//
//  AccountEditViewDependencies.swift
//

import Foundation

protocol PresenterForAccountEditView: ObservableObject {
    var name: String { get set }
    var isSaveButtonDisabled: Bool { get }
    
    func commit()
    func cancel()
}
