//
//  AccountNavigationSubLifetime.swift
//

enum AccountNavigationSubLifetime<Factory: FactoryForAccountNavigationLifecycle> {
    case info(Factory.AccountInfoLifetime)
    case detail(Factory.AccountDetailLifetime)
}
