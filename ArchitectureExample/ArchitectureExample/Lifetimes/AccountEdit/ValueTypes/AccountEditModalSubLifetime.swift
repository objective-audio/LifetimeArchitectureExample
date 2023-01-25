//
//  AccountEditModalSubLifetime.swift
//

enum AccountEditModalSubLifetime<Factory: FactoryForAccountEditModalLifecycle> {
    case alert(Factory.AccountEditAlertLifetime)
}
