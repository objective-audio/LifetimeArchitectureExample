//
//  AccountNavigationElement.swift
//

enum AccountNavigationElement: Equatable {
    case menu(lifetimeId: AccountMenuLifetimeId)
    case info(uiSystem: UISystem,
              lifetimeId: AccountInfoLifetimeId)
}
