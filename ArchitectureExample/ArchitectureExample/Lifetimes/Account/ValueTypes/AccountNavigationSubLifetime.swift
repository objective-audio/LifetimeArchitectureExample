//
//  AccountNavigationSubLifetime.swift
//

enum AccountNavigationSubLifetime {
    case menu(AccountMenuLifetime)
    case info(AccountInfoLifetime)
    case detail(AccountDetailLifetime)
}
