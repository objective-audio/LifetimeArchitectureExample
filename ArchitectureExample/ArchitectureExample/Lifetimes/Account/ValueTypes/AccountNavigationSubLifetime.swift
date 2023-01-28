//
//  AccountNavigationSubLifetime.swift
//

enum AccountNavigationSubLifetime<Factory: FactoryForAccountNavigationLifecycle> {
    case menu(Factory.AccountMenuLifetime)
    case info(Factory.AccountInfoLifetime)
    case detail(Factory.AccountDetailLifetime)
}
