//
//  AccountEditInteractorDependencies.swift
//

protocol AccountInteractorForAccountEdit: AnyObject {
    var name: String { get set }
}

protocol RootModalLevelRouterForAccountEdit: AnyObject {
    func hideAccountEdit(accountLevelId: AccountLevelId)
}

protocol AccountEditModalLevelRouterForAccountEdit: AnyObject {
    func showAlert(content: AccountEditAlertContent)
}
