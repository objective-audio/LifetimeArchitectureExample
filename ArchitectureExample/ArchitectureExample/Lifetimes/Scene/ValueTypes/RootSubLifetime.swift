//
//  RootSubLifetime.swift
//

enum RootSubLifetime<Accessor: LifetimeAccessable> {
    case launch(LaunchLifetime)
    case login(LoginLifetime)
    case account(AccountLifetime<Accessor>)
}
