//
//  RootModalSubLifetime.swift
//

enum RootModalSubLifetime<Accessor: LifetimeAccessable> {
    case alert(RootAlertLifetime)
    case accountEdit(AccountEditLifetime<Accessor>)
}
