//
//  AccountNavigationElement.swift
//

enum AccountNavigationElement: Hashable {
    case info(uiSystem: UISystem,
              lifetimeId: AccountInfoLifetimeId)
    case detail(lifetimeId: AccountDetailLifetimeId)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .info(let uiSystem, let lifetimeId):
            hasher.combine(uiSystem)
            hasher.combine(lifetimeId)
        case .detail(let lifetimeId):
            hasher.combine(lifetimeId)

        }
    }
}
