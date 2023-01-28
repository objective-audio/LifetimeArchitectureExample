//
//  RootSubLifetime.swift
//

enum RootSubLifetime<Factory: FactoryForRootLifecycle> {
    case launch(Factory.LaunchLifetime)
    case login(Factory.LoginLifetime)
    case account(Factory.AccountLifetime)
}
