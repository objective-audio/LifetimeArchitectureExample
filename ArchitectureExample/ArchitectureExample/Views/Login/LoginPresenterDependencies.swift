//
//  LoginPresenterDependencies.swift
//

import Combine

protocol LoginInteractorForPresenter: AnyObject {
    var accountId: String { get set }
    var isValidPublisher: AnyPublisher<Bool, Never> { get }
    var isConnectingPublisher: AnyPublisher<Bool, Never> { get }
    var canOperatePublisher: AnyPublisher<Bool, Never> { get }
    
    func login()
    func cancel()
}
