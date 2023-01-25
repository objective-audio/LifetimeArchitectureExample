//
//  RootModalSubLifetime.swift
//

enum RootModalSubLifetime<Factory: FactoryForRootModalLifecycle> {
    case alert(Factory.RootAlertLifetime)
    case accountEdit(Factory.AccountEditLifetime)
}
