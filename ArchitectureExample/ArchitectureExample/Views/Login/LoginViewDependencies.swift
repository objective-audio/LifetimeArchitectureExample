//
//  LoginViewDependencies.swift
//

import Foundation

protocol PresenterForLoginView: ObservableObject {
    var accountId: String { get set }

    var isTextFieldDisabled: Bool { get }
    var isActivityIndicatorEnabled: Bool { get }
    var isLoginButtonDisabled: Bool { get }
    var isCancelButtonEnabled: Bool { get }

    func login()
    func cancel()
}
