//
//  AccountInfoLifetime.swift
//

/**
 アカウント情報画面の生存期間で必要な機能を保持する
 */

struct AccountInfoLifetime {
    let lifetimeId: AccountInfoLifetimeId
    let uiSystem: UISystem
    let interactor: AccountInfoInteractor
}
