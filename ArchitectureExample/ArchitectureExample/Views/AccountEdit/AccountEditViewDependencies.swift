//
//  AccountEditViewDependencies.swift
//

import Foundation

protocol PresenterForAccountEditView: ObservableObject {
    var name: String { get set }
    var isSaveButtonDisabled: Bool { get }
    var isTextFieldDisabled: Bool { get }

    func commit()
    func cancel()
}
